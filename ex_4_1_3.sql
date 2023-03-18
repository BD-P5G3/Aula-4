DROP TABLE IF EXISTS order_mgmt.rel_prod_enc;
DROP TABLE IF EXISTS order_mgmt.rel_enc_forn;
DROP TABLE IF EXISTS order_mgmt.encomenda;
DROP TABLE IF EXISTS order_mgmt.fornecedor;
DROP TABLE IF EXISTS order_mgmt.produto;
DROP TABLE IF EXISTS order_mgmt.empresa;
DROP SCHEMA IF EXISTS order_mgmt; -- Zé, mgmt ou management?
GO

CREATE SCHEMA order_mgmt;
GO

CREATE TABLE order_mgmt.empresa (
    nif                     INT             NOT NULL    PRIMARY KEY
    CHECK (nif > 100000000)
)

CREATE TABLE order_mgmt.produto (
    codigo                  INT             NOT NULL    PRIMARY KEY,
    preco                   INT             NOT NULL,
    taxa_de_iva             INT             NOT NULL    DEFAULT 23,
    unidades_armazem        INT             NOT NULL    DEFAULT 0,
    nif                     INT             NOT NULL,
    FOREIGN KEY (nif) REFERENCES order_mgmt.empresa(nif) ON UPDATE CASCADE,
    CHECK (preco >= 0), -- It can be a gift, hence why it can cost 0€
    CHECK (taxa_de_iva >= 0),
)

CREATE TABLE order_mgmt.encomenda (
    numero                  INT             NOT NULL    PRIMARY KEY,
    data_encomenda          DATE            NOT NULL,
    nif                     INT             NOT NULL
)

CREATE TABLE order_mgmt.rel_prod_enc (
    codigo_produto          INT             NOT NULL    REFERENCES order_mgmt.produto(codigo) ON UPDATE CASCADE,
    numero_encomenda        INT             NOT NULL    REFERENCES order_mgmt.encomenda(numero) ON UPDATE CASCADE
)

CREATE TABLE order_mgmt.fornecedor (
    nif                     INT             NOT NULL    PRIMARY KEY,
    nome                    VARCHAR(100),
    fax                     INT,
    codigo_de_tipo          INT             NOT NULL,
    condicoes_pagamento     INT             NOT NULL    DEFAULT 30,
    CHECK (condicoes_pagamento >= 0),
    CHECK (nif > 100000000)
)

CREATE TABLE order_mgmt.rel_enc_forn (
    numero_encomenda        INT             NOT NULL    REFERENCES order_mgmt.encomenda(numero) ON UPDATE CASCADE,
    nif_fornecedor          INT             NOT NULL    REFERENCES order_mgmt.fornecedor(nif) ON UPDATE CASCADE
)

ALTER TABLE order_mgmt.encomenda ADD CONSTRAINT nif FOREIGN KEY (nif) REFERENCES order_mgmt.fornecedor(nif)