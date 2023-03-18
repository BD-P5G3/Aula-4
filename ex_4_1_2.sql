-- Exercício 4.1.2
DROP TABLE IF EXISTS FLIGHT_RESERVATION.CAN_LAND;
DROP TABLE IF EXISTS FLIGHT_RESERVATION.FARE;
DROP TABLE IF EXISTS FLIGHT_RESERVATION.SEAT;
DROP TABLE IF EXISTS FLIGHT_RESERVATION.LEG_INSTANCE;
DROP TABLE IF EXISTS FLIGHT_RESERVATION.AIRPLANE;
DROP TABLE IF EXISTS FLIGHT_RESERVATION.AIRPLANE_TYPE;
DROP TABLE IF EXISTS FLIGHT_RESERVATION.FLIGHT_LEG;
DROP TABLE IF EXISTS FLIGHT_RESERVATION.FLIGHT;
DROP TABLE IF EXISTS FLIGHT_RESERVATION.AIRPORT;
DROP SCHEMA IF EXISTS FLIGHT_RESERVATION;
GO

CREATE SCHEMA FLIGHT_RESERVATION;
GO

CREATE TABLE FLIGHT_RESERVATION.AIRPORT (
    code                    VARCHAR(20)      NOT NULL    PRIMARY KEY,
    city                    VARCHAR(100)    NOT NULL,
    state                   VARCHAR(50),
    name                    VARCHAR(100)    NOT NULL
);

CREATE TABLE FLIGHT_RESERVATION.FLIGHT (
    number                  INT             NOT NULL    PRIMARY KEY,
    airline                 VARCHAR(100)    NOT NULL,
    weekdays                INT
);

CREATE TABLE FLIGHT_RESERVATION.FLIGHT_LEG (
    leg_no                  INT             NOT NULL,
    flight_number           INT             NOT NULL,
    airport_code            VARCHAR(20)     NOT NULL,
    scheduled_arr_time      DATETIME        NOT NULL,
    scheduled_dep_time      DATETIME        NOT NULL,
    PRIMARY KEY (leg_no, flight_number),
    FOREIGN KEY (flight_number) REFERENCES FLIGHT_RESERVATION.FLIGHT(number),
    FOREIGN KEY (airport_code) REFERENCES FLIGHT_RESERVATION.AIRPORT(code),
    CHECK (scheduled_dep_time < scheduled_arr_time)
);

CREATE TABLE FLIGHT_RESERVATION.AIRPLANE_TYPE (
    type_name               VARCHAR(100)    NOT NULL    PRIMARY KEY,
    max_seats               INT             DEFAULT 0,
    company                 VARCHAR(100)    NOT NULL
);

CREATE TABLE FLIGHT_RESERVATION.AIRPLANE (
    id                      INT             NOT NULL    PRIMARY KEY,
    total_no_of_seats       INT             DEFAULT 0   CHECK (total_no_of_seats < 1000),
    airplane_type_name      VARCHAR(100)    NOT NULL,
    FOREIGN KEY (airplane_type_name) REFERENCES FLIGHT_RESERVATION.AIRPLANE_TYPE(type_name)
);

CREATE TABLE FLIGHT_RESERVATION.LEG_INSTANCE (
    leg_date                DATE            NOT NULL,
    flight_leg_no           INT             NOT NULL,
    no_of_available_SEATs   INT             NOT NULL,
    arr_time                DATETIME        NOT NULL,
    dep_time                DATETIME        NOT NULL,
    airport_code            VARCHAR(20)     NOT NULL,
    flight_number           INT             NOT NULL,
    airplane_id             INT             NOT NULL,
    PRIMARY KEY (leg_date, flight_leg_no),
    FOREIGN KEY (flight_leg_no, flight_number) REFERENCES FLIGHT_RESERVATION.FLIGHT_LEG(leg_no, flight_number),
    FOREIGN KEY (airport_code) REFERENCES FLIGHT_RESERVATION.AIRPORT(code),
    FOREIGN KEY (airplane_id) REFERENCES FLIGHT_RESERVATION.AIRPLANE(id),
    CHECK (dep_time < arr_time)
);

CREATE TABLE FLIGHT_RESERVATION.SEAT (
    seat_no                 INT             NOT NULL,
    leg_instance_date       DATE            NOT NULL,
    flight_leg_no           INT             NOT NULL,
    c_name                  VARCHAR(25)     NOT NULL,
    c_phone                 INT             NOT NULL,
    PRIMARY KEY (seat_no, leg_instance_date, flight_leg_no),
    FOREIGN KEY (leg_instance_date, flight_leg_no) REFERENCES FLIGHT_RESERVATION.LEG_INSTANCE(leg_date, flight_leg_no),
);

CREATE TABLE FLIGHT_RESERVATION.FARE (
    code                    INT             NOT NULL,
    flight_number           INT             NOT NULL,
    amount                  INT             NOT NULL,
    restrictions            VARCHAR(300)    NOT NULL,

    PRIMARY KEY (code, flight_number),
    FOREIGN KEY (flight_number) REFERENCES FLIGHT_RESERVATION.FLIGHT(number)
);

CREATE TABLE FLIGHT_RESERVATION.CAN_LAND (
    airport_code            VARCHAR(20)     NOT NULL,
    airplane_type_name      VARCHAR(100)    NOT NULL,

    PRIMARY KEY (airport_code, airplane_type_name),
    FOREIGN KEY (airport_code) REFERENCES FLIGHT_RESERVATION.AIRPORT(code),
    FOREIGN KEY (airplane_type_name) REFERENCES FLIGHT_RESERVATION.AIRPLANE_TYPE(type_name)
);