-- Exercício 4.1.2
DROP TABLE IF EXISTS flight_reservation.can_land;
DROP TABLE IF EXISTS flight_reservation.fare;
DROP TABLE IF EXISTS flight_reservation.airplane;
DROP TABLE IF EXISTS flight_reservation.airplane_type;
DROP TABLE IF EXISTS flight_reservation.seat;
DROP TABLE IF EXISTS flight_reservation.leg_instance;
DROP TABLE IF EXISTS flight_reservation.flight_leg;
DROP TABLE IF EXISTS flight_reservation.flight;
DROP TABLE IF EXISTS flight_reservation.airport;
DROP SCHEMA IF EXISTS flight_reservation;
GO

CREATE SCHEMA flight_reservation;
GO

CREATE TABLE flight_reservation.airport (
    code                    INT             NOT NULL    PRIMARY KEY,
    city                    VARCHAR(100)    NOT NULL,
    state                   VARCHAR(50),
    name                    VARCHAR(100)    NOT NULL
)

CREATE TABLE flight_reservation.flight (
    number                  INT             NOT NULL    PRIMARY KEY,
    airline                 VARCHAR(100)    NOT NULL,
    weekdays                INT             NOT NULL
)

CREATE TABLE flight_reservation.flight_leg (
    leg_no                  INT             NOT NULL,
    flight_number           INT             NOT NULL,
    PRIMARY KEY (leg_no, flight_number),
    airport_code            INT             NOT NULL,
    scheduled_arr_time      TIME            NOT NULL,
    scheduled_dep_time      TIME            NOT NULL,

    FOREIGN KEY (flight_number) REFERENCES flight_reservation.flight(number),
    FOREIGN KEY (airport_code) REFERENCES flight_reservation.airport(code)
)

CREATE TABLE flight_reservation.leg_instance (
    leg_date                DATE            NOT NULL,
    flight_leg_no           INT             NOT NULL,
    PRIMARY KEY (leg_date, flight_leg_no),
    no_of_available_seats   BIT             NOT NULL,
    arr_time                TIME            NOT NULL,
    dep_time                TIME            NOT NULL,
    airport_code            INT             NOT NULL,
    flight_number           INT             NOT NULL,
    airplane_id             INT             NOT NULL,
    FOREIGN KEY (flight_leg_no) REFERENCES flight_reservation.flight_leg(leg_no) ON UPDATE CASCADE,
    FOREIGN KEY (airport_code) REFERENCES flight_reservation.airport(code) ON UPDATE CASCADE,
    FOREIGN KEY (flight_number) REFERENCES flight_reservation.flight(number) ON UPDATE CASCADE,
    FOREIGN KEY (airplane_id) REFERENCES flight_reservation.airplane(id) ON UPDATE  CASCADE,
)

CREATE TABLE flight_reservation.seat (
    seat_no                 INT             NOT NULL,
    leg_instance_date       DATE            NOT NULL,
    flight_leg_no           INT             NOT NULL,
    PRIMARY KEY (seat_no, leg_instance_date, flight_leg_no),
    c_name                  VARCHAR(25)     NOT NULL,
    c_phone                 INT             NOT NULL,
    FOREIGN KEY (leg_instance_date) REFERENCES flight_reservation.leg_instance(leg_date) ON UPDATE CASCADE,
    FOREIGN KEY (flight_leg_no) REFERENCES flight_reservation.flight_leg(leg_no) ON UPDATE CASCADE,
)

CREATE TABLE flight_reservation.airplane_type (
    type_name               VARCHAR(100)    NOT NULL    PRIMARY KEY,
    max_seats               INT             NOT NULL,
    company                 VARCHAR(100)    NOT NULL,
)

CREATE TABLE flight_reservation.airplane (
    id                      INT             NOT NULL    PRIMARY KEY,
    total_no_of_seats       INT             NOT NULL,
    airplane_type_name      VARCHAR(100)    NOT NULL,

    FOREIGN KEY (airplane_type_name) REFERENCES flight_reservation.airplane_type(type_name) ON UPDATE CASCADE
)

CREATE TABLE flight_reservation.fare (
    code                    INT             NOT NULL,
    flight_number           INT             NOT NULL,
    amount                  INT             NOT NULL,
    restrictions            VARCHAR(300)    NOT NULL,

    PRIMARY KEY (code, flight_number),
    FOREIGN KEY (flight_number) REFERENCES flight_reservation.flight(number) ON UPDATE CASCADE
)

CREATE TABLE flight_reservation.can_land (
    airport_code            INT             NOT NULL,
    airplane_type_name      VARCHAR(100)    NOT NULL,

    PRIMARY KEY (airport_code, airplane_type_name),
    FOREIGN KEY (airport_code) REFERENCES flight_reservation.airport(code) ON UPDATE CASCADE,
    FOREIGN KEY (airplane_type_name) REFERENCES flight_reservation.airplane_type(type_name) ON UPDATE CASCADE
)