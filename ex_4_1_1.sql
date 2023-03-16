-- Exercício 4.1.1

DROP TABLE IF EXISTS rent_a_car.aluguer;
DROP TABLE IF EXISTS rent_a_car.veiculo;
DROP TABLE IF EXISTS rent_a_car.pesado;
DROP TABLE IF EXISTS rent_a_car.ligeiro;
DROP TABLE IF EXISTS rent_a_car.similaridade;
DROP TABLE IF EXISTS rent_a_car.tipo_veiculo;
DROP TABLE IF EXISTS rent_a_car.balcao;
DROP TABLE IF EXISTS rent_a_car.cliente;
DROP SCHEMA IF EXISTS rent_a_car;
GO

CREATE SCHEMA rent_a_car;
GO

CREATE TABLE rent_a_car.cliente (
    nif             INT             NOT NULL    PRIMARY KEY,
    nome            VARCHAR(100)    NOT NULL,
    endereco        VARCHAR(250),
    num_carta       INT             NOT NULL    UNIQUE
)

CREATE TABLE rent_a_car.balcao (
    numero          INT             NOT NULL    PRIMARY KEY,
    nome            VARCHAR(100)    NOT NULL,
    endereco        VARCHAR(100) 
)

CREATE TABLE rent_a_car.tipo_veiculo (
    codigo          INT             NOT NULL    PRIMARY KEY,
    arcondicionado  BIT,
    designacao      VARCHAR(250)    NOT NULL
)

CREATE TABLE rent_a_car.similaridade (
    codigo1         INT             NOT NULL,
    codigo2         INT             NOT NULL,
    PRIMARY KEY (codigo1, codigo2),

    FOREIGN KEY (codigo1) REFERENCES rent_a_car.tipo_veiculo(codigo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codigo2) REFERENCES rent_a_car.tipo_veiculo(codigo)
)

CREATE TABLE rent_a_car.ligeiro (
    codigo          INT             NOT NULL    PRIMARY KEY,
    combustivel     VARCHAR(50)     NOT NULL,
    portas          INT,
    num_lugares     INT             NOT NULL,
    
    FOREIGN KEY (codigo) REFERENCES rent_a_car.tipo_veiculo(codigo) ON DELETE CASCADE ON UPDATE CASCADE,
)

CREATE TABLE rent_a_car.pesado (
    codigo          INT             NOT NULL    PRIMARY KEY,
    peso            INT,
    passageiros     INT             NOT NULL,

    FOREIGN KEY (codigo) REFERENCES rent_a_car.tipo_veiculo(codigo) ON DELETE CASCADE ON UPDATE CASCADE,
)

CREATE TABLE rent_a_car.veiculo (
    matricula       VARCHAR(6)      NOT NULL    PRIMARY KEY,
    ano             INT             NOT NULL,
    marca           VARCHAR(20)     NOT NULL,
    codigo          INT             NOT NULL,

    FOREIGN KEY (codigo) REFERENCES rent_a_car.tipo_veiculo(codigo) ON UPDATE CASCADE,
)

CREATE TABLE rent_a_car.aluguer(
    numero          INT            NOT NULL     PRIMARY KEY,
    duracao         INT            NOT NULL,
    data_aluguer    DATE           NOT NULL,
    matricula_vei   VARCHAR(6)     NOT NULL,
    nif_cliente     INT            NOT NULL,
    numero_balcao   INT            NOT NULL,

    FOREIGN KEY (matricula_vei) REFERENCES rent_a_car.veiculo(matricula) ON UPDATE CASCADE,
    FOREIGN KEY (nif_cliente) REFERENCES rent_a_car.cliente(nif) ON UPDATE CASCADE,
    FOREIGN KEY (numero_balcao) REFERENCES rent_a_car.balcao(numero) ON UPDATE CASCADE
)