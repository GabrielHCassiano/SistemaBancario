CREATE DATABASE sistema_bancario;
USE sistema_bancario;

CREATE TABLE BANCO (
    codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (codigo)
);

CREATE TABLE AGENCIA (
    cod_banco INT NOT NULL AUTO_INCREMENT,
    numero_agencia varchar(4) NOT NULL,
    endereco VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (numero_agencia),
    FOREIGN KEY (cod_banco) REFERENCES banco (codigo)
);

CREATE TABLE CLIENTE (
    cpf CHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(50) NOT NULL,
    sexo CHAR(1) NOT NULL,
    endereco VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (cpf),
    CHECK (sexo IN ('M', 'F'))
);

CREATE TABLE CONTA (
    numero_conta CHAR(7) NOT NULL,
    saldo DECIMAL(10, 2) NOT NULL,
    tipo_conta CHAR(1) DEFAULT NULL,
    num_agencia varchar(4) NOT NULL,
    CHECK (tipo_conta IN ('1', '2')),
    PRIMARY KEY (numero_conta),
    FOREIGN KEY (num_agencia) REFERENCES agencia (numero_agencia)
);

CREATE TABLE HISTORICO (
    cpf_cliente CHAR(14) NOT NULL UNIQUE,
    num_conta CHAR(7) NOT NULL,
    data_inicio DATE DEFAULT NULL,
    PRIMARY KEY (cpf_cliente, num_conta),
    FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
    FOREIGN KEY (num_conta) REFERENCES conta (numero_conta)
);

CREATE TABLE TELEFONE_CLIENTE (
    cpf_cli CHAR(14) NOT NULL,
    telefone CHAR(15) NOT NULL,
    PRIMARY KEY (cpf_cli, telefone),
    FOREIGN KEY (cpf_cli) REFERENCES cliente (cpf)
);

INSERT INTO BANCO (codigo, nome) value ('1','Banco do Brasil');
INSERT INTO BANCO (codigo, nome) value ('4','CEF');

INSERT INTO AGENCIA (cod_banco, numero_agencia, endereco) values
('4', '322', 'Av. Walfredo Macedo Brandao, 1139'),
('1', '1253', 'R. Bancário Sérgio Guerra, 17');

INSERT INTO CLIENTE (cpf, nome, sexo, endereco) values 
('111.222.333-44', 'Bruna Andrade', 'F', 'Rua José Firmino Ferreira, 1050 '),
('666.777.888-99', 'Radegondes Silva', 'M', 'Av. Epitácio Pessoa, 1008 '),
('555.444.777-33', 'Miguel Xavier', 'M', 'Rua Bancário Sérgio Guerra, 640');

INSERT INTO CONTA (numero_conta, saldo, tipo_conta, num_agencia) values 
('11765-2', '22745.05', '2', '322'),
('21010-7', '3100.96', '1', '1253');

INSERT INTO HISTORICO (cpf_cliente, num_conta, data_inicio) values 
('111.222.333-44', '11765-2', '2015-12-22'),
('666.777.888-99', '11765-2', '2016-10-05'),
('555.444.777-33', '21010-7', '2012-08-29');

INSERT INTO TELEFONE_CLIENTE (cpf_cli, telefone) values 
('111.222.333-44', '(83) 3222-1234'),
('666.777.888-99', '(83) 99443-9999'),
('555.444.777-33', '(83) 3233-2267');

  -- drop database sistema_bancario;