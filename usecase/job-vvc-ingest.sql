-- For more info about faker expressions and providers: https://www.datafaker.net/documentation/getting-started/

CREATE TEMPORARY TABLE fake_events WITH (
  'connector' = 'faker',
  'fields.event_time.expression' = '#{date.past ''10'',''0'',''SECONDS''}',
  'fields.event_type.expression' = '#{regexify ''(cart|purchase|view)''}',
  'fields.product_id.expression' = '#{number.numberBetween ''1'',''11''}',
  'fields.price.expression' = '#{number.randomDouble ''2'',''1'',''100''}',
  'fields.user_id.expression' = '#{number.numberBetween ''0'',''100''}',
  'rows-per-second' = '1'
) LIKE `system`.deepdive2.events (
    EXCLUDING OPTIONS
    INCLUDING WATERMARKS
);

-- select * from fake_events;

CREATE TEMPORARY TABLE fake_users WITH (
  'connector' = 'faker',
  'fields.id.expression' = '#{number.numberBetween ''0'',''100''}',
  'fields.first_name.expression' = '#{Name.firstName}',
  'fields.last_name.expression' = '#{Name.lastName}',
  'fields.address.expression' = '#{Address.fullAddress}',
  'fields.updated_at.expression' = '#{date.past ''10'',''0'',''SECONDS''}',
  'rows-per-second' = '1'
) LIKE `system`.deepdive2.users (
    EXCLUDING OPTIONS
    EXCLUDING GENERATED -- exclude computed column for 'email'
    INCLUDING WATERMARKS
);

-- select * from fake_users;

BEGIN STATEMENT SET;

INSERT INTO `system`.deepdive2.events SELECT * FROM fake_events;
INSERT INTO `system`.deepdive2.users SELECT * FROM fake_users;

INSERT INTO `system`.deepdive2.products values 
  (1, 'Wonderful Shoes', NOW()),
  (2, 'Amazing Toilet Paper', NOW()),
  (3, 'Pink Squirrel', NOW()),
  (4, 'Curry Wurst', NOW()),
  (5, 'Marvelous Grapes', NOW()),
  (6, 'Ugly Shirt', NOW()),
  (7, 'Blasting Ashtray', NOW()),
  (8, 'Rotated Monitor', NOW()),
  (9, 'Huge Mistake', NOW()),
  (10, 'Infinite Joy', NOW());

END;
