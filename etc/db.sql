-- To create the database execute
-- mysql giftmart -u giftmart < db.sql

CREATE TABLE shoppers (
	shopper_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255),
	email VARCHAR(255),
	city VARCHAR(255)
);

CREATE TABLE giftees (
	shopper_id INT NOT NULL,
	age INT NOT NULL,
	gender CHAR(1)
);

CREATE TABLE invitations (
	shopper_id INT NOT NULL,
	invitation_number INT NOT NULL
);
