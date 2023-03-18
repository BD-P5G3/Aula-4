-- Exercício 4.1.4

DROP TABLE IF EXISTS pharmacy_management.rel_drug_pharmacy;
DROP TABLE IF EXISTS pharmacy_management.pharmacy;
DROP TABLE IF EXISTS pharmacy_management.rel_drug_pharmaceutical;
DROP TABLE IF EXISTS pharmacy_management.pharmaceutical;
DROP TABLE IF EXISTS pharmacy_management.rel_presc_drug;
DROP TABLE IF EXISTS pharmacy_management.drug;
DROP TABLE IF EXISTS pharmacy_management.prescription;
DROP TABLE IF EXISTS pharmacy_management.user;
DROP TABLE IF EXISTS pharmacy_management.doctor;
DROP SCHEMA IF EXISTS pharmacy_management;
GO

CREATE SCHEMA pharmacy_management;
GO

CREATE TABLE pharmacy_management.doctor (
    number          INT             NOT NULL         PRIMARY KEY,
    name            VARCHAR(30)     NOT NULL         UNIQUE,
    specialty       VARCHAR(100)    NOT NULL,
);

CREATE TABLE pharmacy_management.user (
    number          INT             NOT NULL        PRIMARY KEY,
    name            VARCHAR(30)     NOT NULL        UNIQUE,
    birth_date      DATE            NOT NULL,
    address         VARCHAR(100)    NOT NULL,
);

CREATE TABLE pharmacy_management.prescription (
    number          INT             NOT NULL         PRIMARY KEY,
    creation_date   DATE            NOT NULL,
    dispatch_date   DATE            NOT NULL,
    doctor_number   INT             NOT NULL,
    user_number     INT             NOT NULL,
    user_nif        INT             NOT NULL,

    FOREIGN KEY (doctor_number) REFERENCES pharmacy_management.doctor(number),
    FOREIGN KEY (user_number) REFERENCES pharmacy_management.user(number),
    FOREIGN KEY (user_nif) REFERENCES pharmacy_management.user(nif)
);

CREATE TABLE pharmacy_management.drug (
    formula         VARCHAR(100)    NOT NULL        PRIMARY KEY,
);

CREATE TABLE pharmacy_management.rel_presc_drug (
    presc_number    INT             NOT NULL,
    drug_formula    VARCHAR(100)    NOT NULL,

    PRIMARY KEY (presc_number, drug_formula),
    FOREIGN KEY (presc_number) REFERENCES pharmacy_management.prescription(number),
    FOREIGN KEY (drug_formula) REFERENCES pharmacy_management.drug(formula)
);

CREATE TABLE pharmacy_management.pharmaceutical (
    register_number INT             NOT NULL        PRIMARY KEY,
    name            VARCHAR(30)     NOT NULL        UNIQUE,
    phone_number    INT             NOT NULL        UNIQUE,
    address         VARCHAR(100)    NOT NULL,
);

CREATE TABLE pharmacy_management.rel_drug_pharmaceutical (
    drug_formula    VARCHAR(100)    NOT NULL,
    register_number INT             NOT NULL,

    PRIMARY KEY (drug_formula, register_number),
    FOREIGN KEY (drug_formula) REFERENCES pharmacy_management.drug(formula),
    FOREIGN KEY (register_number) REFERENCES pharmacy_management.pharmaceutical(register_number),
);

CREATE TABLE pharmacy_management.pharmacy (
    nif             INT             NOT NULL        PRIMARY KEY,
    name            VARCHAR(30)     NOT NULL        UNIQUE,
    phone_number    INT             NOT NULL        UNIQUE,
    address         VARCHAR(100)    NOT NULL,
);

CREATE TABLE pharmacy_management.rel_drug_pharmacy (
    drug_formula    VARCHAR(100)    NOT NULL,
    pharmacy_nif    INT             NOT NULL,

    PRIMARY KEY (drug_formula, pharmacy_nif),
    FOREIGN KEY (drug_formula) REFERENCES pharmacy_management.drug(drug_formula),
    FOREIGN KEY (pharmacy_nif) REFERENCES pharmacy_management.pharmacy(nif)
);