DROP TABLE IF EXISTS CONFERENCES.REL_ARTIGO_AUTOR;
DROP TABLE IF EXISTS CONFERENCES.NAO_ESTUDANTE;
DROP TABLE IF EXISTS CONFERENCES.ESTUDANTE;
DROP TABLE IF EXISTS CONFERENCES.PARTICIPANTE;
DROP TABLE IF EXISTS CONFERENCES.AUTOR;
DROP TABLE IF EXISTS CONFERENCES.PESSOA;
DROP TABLE IF EXISTS CONFERENCES.INSTITUICAO;
DROP TABLE IF EXISTS CONFERENCES.ARTIGO_CIENTIFICO;
DROP SCHEMA IF EXISTS CONFERENCES;
GO

CREATE SCHEMA CONFERENCES;
GO

CREATE TABLE CONFERENCES.ARTIGO_CIENTIFICO (
    numero_registo          INT             NOT NULL    PRIMARY KEY,
    titulo                  VARCHAR(250)    NOT NULL
)

CREATE TABLE CONFERENCES.INSTITUICAO (
    endereco                VARCHAR(250)    NOT NULL    PRIMARY KEY,
    nome                    VARCHAR(250)    NOT NULL
)

CREATE TABLE CONFERENCES.PESSOA (
    email                   VARCHAR(250)    NOT NULL    PRIMARY KEY,
    nome                    VARCHAR(250)    NOT NULL
)

CREATE TABLE CONFERENCES.AUTOR (
    email                   VARCHAR(250)    NOT NULL    PRIMARY KEY,
    endereco_INSTITUICAO    VARCHAR(250)    NOT NULL,
    FOREIGN KEY (email) REFERENCES CONFERENCES.PESSOA(email) ON UPDATE CASCADE,
    FOREIGN KEY (endereco_INSTITUICAO) REFERENCES CONFERENCES.INSTITUICAO(endereco) ON UPDATE CASCADE
)

CREATE TABLE CONFERENCES.PARTICIPANTE (
    email                   VARCHAR(250)    NOT NULL    PRIMARY KEY,
    data_inscricao          DATE            NOT NULL,
    morada                  VARCHAR(250),
    custo_inscricao         INT             NOT NULL    DEFAULT 0,
    FOREIGN KEY (email) REFERENCES CONFERENCES.PESSOA(email) ON UPDATE CASCADE
)

CREATE TABLE CONFERENCES.ESTUDANTE (
    email                   VARCHAR(250)    NOT NULL    PRIMARY KEY,
    comprovativo            VARCHAR(500)    NOT NULL,
    FOREIGN KEY (email) REFERENCES CONFERENCES.PARTICIPANTE(email) ON UPDATE CASCADE
)

CREATE TABLE CONFERENCES.NAO_ESTUDANTE (
    email                   VARCHAR(250)    NOT NULL    PRIMARY KEY,
    referencia_transacao    VARCHAR(250)    NOT NULL,
    FOREIGN KEY (email) REFERENCES CONFERENCES.PARTICIPANTE(email) ON UPDATE CASCADE
)

CREATE TABLE CONFERENCES.REL_ARTIGO_AUTOR (
    numero_registo          INT             NOT NULL,
    email_AUTOR             VARCHAR(250)    NOT NULL,
    PRIMARY KEY (numero_registo, email_AUTOR),
    FOREIGN KEY (numero_registo) REFERENCES CONFERENCES.ARTIGO_CIENTIFICO(numero_registo),
    FOREIGN KEY (email_AUTOR) REFERENCES CONFERENCES.AUTOR(email) ON UPDATE CASCADE
)