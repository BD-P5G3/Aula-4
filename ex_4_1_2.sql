-- Exercício 4.1.2
DROP TABLE IF EXISTS flight_reservation.can_land;
DROP TABLE IF EXISTS flight_reservation.fare;
DROP TABLE IF EXISTS flight_reservation.seat;
DROP TABLE IF EXISTS flight_reservation.leg_instance;
DROP TABLE IF EXISTS flight_reservation.airplane;
DROP TABLE IF EXISTS flight_reservation.airplane_type;
DROP TABLE IF EXISTS flight_reservation.flight_leg;
DROP TABLE IF EXISTS flight_reservation.flight;
DROP TABLE IF EXISTS flight_reservation.airport;
DROP SCHEMA IF EXISTS flight_reservation;
GO

CREATE SCHEMA flight_reservation;
GO

CREATE TABLE flight_reservation.airport (
    code                    VARCHAR(20)      NOT NULL    PRIMARY KEY,
    city                    VARCHAR(100)    NOT NULL,
    state                   VARCHAR(50),
    name                    VARCHAR(100)    NOT NULL
);

CREATE TABLE flight_reservation.flight (
    number                  INT             NOT NULL    PRIMARY KEY,
    airline                 VARCHAR(100)    NOT NULL,
    weekdays                INT
);

CREATE TABLE flight_reservation.flight_leg (
    leg_no                  INT             NOT NULL,
    flight_number           INT             NOT NULL,
    airport_code            VARCHAR(20)     NOT NULL,
    scheduled_arr_time      DATETIME        NOT NULL,
    scheduled_dep_time      DATETIME        NOT NULL,
    PRIMARY KEY (leg_no, flight_number),
    FOREIGN KEY (flight_number) REFERENCES flight_reservation.flight(number),
    FOREIGN KEY (airport_code) REFERENCES flight_reservation.airport(code),
    CHECK (scheduled_dep_time < scheduled_arr_time)
);

CREATE TABLE flight_reservation.airplane_type (
    type_name               VARCHAR(100)    NOT NULL    PRIMARY KEY,
    max_seats               INT             DEFAULT 0,
    company                 VARCHAR(100)    NOT NULL
);

CREATE TABLE flight_reservation.airplane (
    id                      INT             NOT NULL    PRIMARY KEY,
    total_no_of_seats       INT             DEFAULT 0   CHECK (total_no_of_seats < 1000),
    airplane_type_name      VARCHAR(100)    NOT NULL,
    FOREIGN KEY (airplane_type_name) REFERENCES flight_reservation.airplane_type(type_name)
);

CREATE TABLE flight_reservation.leg_instance (
    leg_date                DATE            NOT NULL,
    flight_leg_no           INT             NOT NULL,
    no_of_available_seats   INT             NOT NULL,
    arr_time                DATETIME        NOT NULL,
    dep_time                DATETIME        NOT NULL,
    airport_code            VARCHAR(20)     NOT NULL,
    flight_number           INT             NOT NULL,
    airplane_id             INT             NOT NULL,
    PRIMARY KEY (leg_date, flight_leg_no),
    FOREIGN KEY (flight_leg_no, flight_number) REFERENCES flight_reservation.flight_leg(leg_no, flight_number),
    FOREIGN KEY (airport_code) REFERENCES flight_reservation.airport(code),
    FOREIGN KEY (airplane_id) REFERENCES flight_reservation.airplane(id),
    CHECK (dep_time < arr_time)
);

CREATE TABLE flight_reservation.seat (
    seat_no                 INT             NOT NULL,
    leg_instance_date       DATE            NOT NULL,
    flight_leg_no           INT             NOT NULL,
    c_name                  VARCHAR(25)     NOT NULL,
    c_phone                 INT             NOT NULL,
    PRIMARY KEY (seat_no, leg_instance_date, flight_leg_no),
    FOREIGN KEY (leg_instance_date, flight_leg_no) REFERENCES flight_reservation.leg_instance(leg_date, flight_leg_no),
);

CREATE TABLE flight_reservation.fare (
    code                    INT             NOT NULL,
    flight_number           INT             NOT NULL,
    amount                  INT             NOT NULL,
    restrictions            VARCHAR(300)    NOT NULL,

    PRIMARY KEY (code, flight_number),
    FOREIGN KEY (flight_number) REFERENCES flight_reservation.flight(number)
);

CREATE TABLE flight_reservation.can_land (
    airport_code            VARCHAR(20)     NOT NULL,
    airplane_type_name      VARCHAR(100)    NOT NULL,

    PRIMARY KEY (airport_code, airplane_type_name),
    FOREIGN KEY (airport_code) REFERENCES flight_reservation.airport(code),
    FOREIGN KEY (airplane_type_name) REFERENCES flight_reservation.airplane_type(type_name)
);