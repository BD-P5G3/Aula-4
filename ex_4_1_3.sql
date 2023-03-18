DROP TABLE IF EXISTS ORDER_MANAGEMENT.REL_PROD_ENC;
DROP TABLE IF EXISTS ORDER_MANAGEMENT.REL_ENC_FORN;
DROP TABLE IF EXISTS ORDER_MANAGEMENT.ENCOMENDA;
DROP TABLE IF EXISTS ORDER_MANAGEMENT.FORNECEDOR;
DROP TABLE IF EXISTS ORDER_MANAGEMENT.PRODUTO;
DROP TABLE IF EXISTS ORDER_MANAGEMENT.EMPRESA;
DROP SCHEMA IF EXISTS ORDER_MANAGEMENT;
GO

CREATE SCHEMA ORDER_MANAGEMENT;
GO

CREATE TABLE ORDER_MANAGEMENT.EMPRESA (
    nif                     INT             NOT NULL    PRIMARY KEY
    CHECK (nif > 100000000)
)

CREATE TABLE ORDER_MANAGEMENT.PRODUTO (
    codigo                  INT             NOT NULL    PRIMARY KEY,
    preco                   INT             NOT NULL,
    taxa_de_iva             INT             NOT NULL    DEFAULT 23,
    unidades_armazem        INT             NOT NULL    DEFAULT 0,
    nif                     INT             NOT NULL,
    FOREIGN KEY (nif) REFERENCES ORDER_MANAGEMENT.EMPRESA(nif) ON UPDATE CASCADE,
    CHECK (preco >= 0), -- It can be a gift, hence why it can cost 0€
    CHECK (taxa_de_iva >= 0),
)

CREATE TABLE ORDER_MANAGEMENT.ENCOMENDA (
    numero                  INT             NOT NULL    PRIMARY KEY,
    data_encomenda          DATE            NOT NULL,
    nif                     INT             NOT NULL
)

CREATE TABLE ORDER_MANAGEMENT.REL_PROD_ENC (
    codigo_produto          INT             NOT NULL    REFERENCES ORDER_MANAGEMENT.PRODUTO(codigo) ON UPDATE CASCADE,
    numero_encomenda        INT             NOT NULL    REFERENCES ORDER_MANAGEMENT.ENCOMENDA(numero) ON UPDATE CASCADE,
    PRIMARY KEY (codigo_produto, numero_encomenda)
)

CREATE TABLE ORDER_MANAGEMENT.FORNECEDOR (
    nif                     INT             NOT NULL    PRIMARY KEY,
    nome                    VARCHAR(100),
    fax                     INT,
    codigo_de_tipo          INT             NOT NULL,
    condicoes_pagamento     INT             NOT NULL    DEFAULT 30,
    CHECK (condicoes_pagamento >= 0),
    CHECK (nif > 100000000)
)

CREATE TABLE ORDER_MANAGEMENT.REL_ENC_FORN (
    numero_encomenda        INT             NOT NULL    REFERENCES ORDER_MANAGEMENT.ENCOMENDA(numero) ON UPDATE CASCADE,
    nif_fornecedor          INT             NOT NULL    REFERENCES ORDER_MANAGEMENT.FORNECEDOR(nif) ON UPDATE CASCADE,
    PRIMARY KEY (numero_encomenda, nif_fornecedor)
)

ALTER TABLE ORDER_MANAGEMENT.ENCOMENDA ADD CONSTRAINT nif FOREIGN KEY (nif) REFERENCES ORDER_MANAGEMENT.FORNECEDOR(nif)