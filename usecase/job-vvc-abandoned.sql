CREATE TEMPORARY VIEW sessioned_events AS
SELECT *
FROM TABLE(
    HOP(
        DATA => TABLE `system`.deepdive2.events_clean,
        TIMECOL => DESCRIPTOR(event_time),
        SIZE => INTERVAL '1' MINUTE, -- dummy value to see results quickly
        SLIDE => INTERVAL '10' SECONDS -- dummy value to see results quickly
    )
);

-- select * from sessioned_events;

CREATE TEMPORARY VIEW agg_events AS
SELECT window_start, window_end, window_time as rowtime, user_id, product_id, arrayagg(event_type) AS e
FROM sessioned_events
GROUP BY window_start, window_end, window_time, user_id, product_id;

-- select * from agg_events;

CREATE TEMPORARY VIEW w_abandoned AS
SELECT *, IF(ARRAY_CONTAINS(e, 'cart') AND NOT ARRAY_CONTAINS(e, 'purchase'), 1, 0) AS abandoned
FROM agg_events;

-- select * from w_abandoned;

CREATE TEMPORARY VIEW abandoned_carts AS
SELECT * FROM w_abandoned
WHERE abandoned = 1;

-- -- select * from abandoned_carts;

SET 'table.exec.source.idle-timeout' = '15s';

CREATE TEMPORARY VIEW final_output AS
SELECT
    u.id AS user_id,
    CONCAT_WS(' ', u.first_name, u.last_name) AS full_name,
    u.email,
    u.address,
    p.id AS product_id,
    p.name AS product_name,
    PROCTIME() AS last_updated
FROM abandoned_carts AS a
JOIN `system`.deepdive2.users FOR SYSTEM_TIME AS OF a.rowtime AS u ON a.user_id = u.id
JOIN `system`.deepdive2.products FOR SYSTEM_TIME AS OF a.rowtime AS p ON a.product_id = p.id;

-- select * from final_output; -- Does not work.

INSERT INTO `system`.deepdive2.abandoned SELECT * from final_output;
