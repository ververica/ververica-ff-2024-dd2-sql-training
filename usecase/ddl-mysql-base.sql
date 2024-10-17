CREATE TABLE users (
    id INT NOT NULL, -- AUTO_INCREMENT,
    first_name VARCHAR(64),
    last_name VARCHAR(64),
    `address` VARCHAR(256),
    updated_at TIMESTAMP(3),

    PRIMARY KEY (id)
);

CREATE TABLE products (
    id INT NOT NULL, -- AUTO_INCREMENT,
    `name` VARCHAR(64),
    updated_at TIMESTAMP(3),

    PRIMARY KEY (id)
);
