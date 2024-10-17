INSERT INTO `system`.deepdive2.events_clean
SELECT * FROM `system`.deepdive2.events
WHERE event_type='purchase' OR event_type='cart';
