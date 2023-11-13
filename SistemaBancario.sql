-- 1. Crie o Banco de Dados chamado sistema_bancario;
CREATE DATABASE sistema_bancario;
USE sistema_bancario;
SET SQL_SAFE_UPDATES = 0;

-- 2. No banco de dados, crie as relações abaixo, especificando as restrições de atributo e as ações disparadaspor integridade referencial.
CREATE TABLE BANCO (
    codigo SMALLINT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    PRIMARY KEY (codigo)
);

CREATE TABLE AGENCIA (
    cod_banco SMALLINT NOT NULL AUTO_INCREMENT,
    numero_agencia varchar(4) NOT NULL,
    endereco VARCHAR(50) NOT NULL,
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
    CHECK (tipo_conta IN ('1', '2', '3')),
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

-- 3. Acrescente as tuplas das relações mostradas na figura abaixo de um possível estado de banco de dados,em seguida, crie uma tupla com os dados de sua preferência para cada tabela, mas lembre-se que o nomedo cliente é o seu
INSERT INTO BANCO (codigo, nome) values
 ('1' ,'Banco do Brasil'),
('4' ,'CEF'),
('7' ,'Bom Dia');


INSERT INTO AGENCIA (cod_banco, numero_agencia, endereco) values
('4', '322', 'Av. Walfredo Macedo Brandao, 1139'),
('1', '1253', 'R. Bancário Sérgio Guerra, 17'),
('7', '77', 'Av. Lauro Souza de Michel, 11');

INSERT INTO CLIENTE (cpf, nome, sexo, endereco) values 
('111.222.333-44', 'Bruna Andrade', 'F', 'Rua José Firmino Ferreira, 1050 '),
('666.777.888-99', 'Radegondes Silva', 'M', 'Av. Epitácio Pessoa, 1008 '),
('555.444.777-33', 'Miguel Xavier', 'M', 'Rua Bancário Sérgio Guerra, 640'),
('715.320.777-55', 'Gabriel Henriques', 'M', 'Av. Lauro Souza de Michel, 11');

INSERT INTO CONTA (numero_conta, saldo, tipo_conta, num_agencia) values 
('11765-2', '22745.05', '2', '322'),
('21010-7', '3100.96', '1', '1253'),
('15015-7', '50.00', '3', '77');

INSERT INTO HISTORICO (cpf_cliente, num_conta, data_inicio) values 
('111.222.333-44', '11765-2', '2015-12-22'),
('666.777.888-99', '11765-2', '2016-10-05'),
('555.444.777-33', '21010-7', '2012-08-29'),
('715.320.777-55', '15015-7', '2004-03-15');

INSERT INTO TELEFONE_CLIENTE (cpf_cli, telefone) values 
('111.222.333-44', '(83) 3222-1234'),
('666.777.888-99', '(83) 99443-9999'),
('555.444.777-33', '(83) 3233-2267'),
('715.320.777-55', '(83) 99606-1522');

-- 4. Adicione a coluna país com o tipo char(3) e valor default ‘BRA’ na tabela cliente.
ALTER TABLE CLIENTE ADD COLUMN país char(3) DEFAULT 'BRA';

-- 5. Altere a tabela cliente e crie um novo atributo chamado email para armazenar os emails dos clientes.
ALTER TABLE CLIENTE ADD COLUMN email varchar(30) not null;

-- 6. Exclua a conta 11765-2.
ALTER TABLE HISTORICO DROP FOREIGN KEY historico_ibfk_2;
DELETE FROM CONTA WHERE numero_conta = '11765-2';

-- 7. Altere o número da agência 322 para 6342.
UPDATE CONTA, AGENCIA SET numero_agencia = '6342' WHERE num_agencia = numero_agencia = '322';

-- 8. Modifique o tipo da coluna Numero_conta para char(7) na tabela conta.
ALTER TABLE CONTA MODIFY numero_conta char(7);

-- 9. Altere o registro do cliente Radegondes Silva acrescentando o email radegondes.silva@gmail.com.
UPDATE CLIENTE SET email = 'radegondes.silva@gmail.com' WHERE cpf = '666.777.888-99';

-- 10. Conceda à conta 21010-7 um aumento de 10 por cento no saldo.
UPDATE CONTA SET saldo = saldo * 1.10 WHERE numero_conta = '21010-7';

-- 11. Altere o nome da cliente Bruna Andrade para Bruna Fernandes.
UPDATE CLIENTE SET nome = 'Bruna Fernandes' WHERE cpf = '111.222.333-44';

-- 12. Modifique o tipo de conta para 3 nas contas que possuem saldo maior que R$ 10.000,00.
UPDATE CONTA SET tipo_conta = '3' WHERE saldo > 10000.00;

-- 13. Desenvolva uma consulta que retorne o nome e o sexo dos clientes ordenados pelo nome de formadescendente.
SELECT nome, sexo FROM CLIENTE ORDER BY nome DESC;

-- 14. Desenvolva uma consulta que retorne a quantidade total dos saldos nas contas da agência.
SELECT AG.numero_agencia, SUM(CON.saldo) AS total_saldo 
FROM AGENCIA AG LEFT JOIN CONTA CON ON AG.numero_agencia = CON.num_agencia GROUP BY AG.numero_agencia;

-- 15. Desenvolva uma consulta que retorne a quantidade de clientes cadastrados na agência.
SELECT AG.numero_agencia, COUNT(DISTINCT C.cpf) AS quantidade_de_clientes 
FROM AGENCIA AG LEFT JOIN CONTA CON 
ON AG.numero_agencia = CON.num_agencia LEFT JOIN HISTORICO H 
ON CON.numero_conta = H.num_conta LEFT JOIN CLIENTE C 
ON H.cpf_cliente = C.cpf GROUP BY AG.numero_agencia;

-- 16. Desenvolva uma consulta que retorne o nome do cliente, seu endereço e o número de sua conta.
SELECT CLIENTE.nome, CLIENTE.endereco, HISTORICO.num_conta FROM CLIENTE JOIN HISTORICO ON CLIENTE.cpf = HISTORICO.cpf_cliente;

-- 17. Desenvolva uma consulta que retorne a quantidade de pessoas cadastrados separados por sexo.
SELECT sexo, COUNT(*) AS quantidade_de_pessoas FROM CLIENTE GROUP BY sexo;

-- 18. Desenvolva uma consulta que retorne o nome do cliente com o maior saldo bancário.
SELECT CLIENTE.nome, CONTA.saldo FROM CLIENTE JOIN HISTORICO 
ON CLIENTE.cpf = HISTORICO.cpf_cliente JOIN CONTA 
ON HISTORICO.num_conta = CONTA.numero_conta 
WHERE CONTA.saldo = (SELECT MAX(saldo) FROM CONTA);

-- 19. Desenvolva uma consulta que retorne em uma nova coluna o saldo bancário de cada cliente caso seja dado um aumento de 3,5%, lembre de deixar ao lado dessa coluna o valor do saldo bancário que está armazenado.
SELECT CLIENTE.nome, CONTA.saldo, round (CONTA.saldo * 1.035, 2) AS saldo_com_aumento 
FROM CLIENTE JOIN HISTORICO ON CLIENTE.cpf = HISTORICO.cpf_cliente JOIN CONTA ON HISTORICO.num_conta = CONTA.numero_conta;

-- 20. Desenvolva uma consulta que retorne o nome dos clientes que moram no endereço iniciando por Av.
SELECT nome FROM CLIENTE WHERE endereco LIKE 'Av.%';