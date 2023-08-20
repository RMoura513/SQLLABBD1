CREATE DATABASE exercicio1
GO
USE exercicio1

CREATE TABLE motorista (
codigo			INT				NOT NULL,
nome			VARCHAR(50)		NOT NULL,
naturalidade	VARCHAR(50)		NOT NULL
PRIMARY KEY (codigo))
GO
CREATE TABLE onibus (
placa			VARCHAR(10)		NOT NULL,
marca			VARCHAR(20)		NOT NULL,
ano				INT				NOT NULL,
descricao		VARCHAR(50)		NOT NULL
PRIMARY KEY (placa))
GO
CREATE TABLE viagem (
codigo			INT				NOT NULL,
onibusPlaca		VARCHAR(10)		NOT NULL,
motoristaCodigo	INT				NOT NULL,
horaSaida		INT				NOT NULL,
horaChegada		INT				NOT NULL,
partida			VARCHAR(20)		NOT NULL,
destino			VARCHAR(20)		NOT NULL
PRIMARY KEY (codigo),
FOREIGN KEY (onibusPlaca) REFERENCES onibus (placa),
FOREIGN KEY (motoristaCodigo) REFERENCES motorista (codigo),
CHECK (horaSaida>=0),
CHECK (horaChegada>=0))


SELECT * FROM motorista
SELECT * FROM onibus
SELECT * FROM viagem

--1) Criar um Union das tabelas Motorista e ônibus, com as colunas ID (Código e Placa) e Nome (Nome e Marca)
SELECT CAST(codigo AS VARCHAR(10)) AS ID, nome AS nome FROM motorista
UNION
SELECT placa AS ID, marca AS nome FROM onibus



--2) Criar uma View (Chamada v_motorista_onibus) do Union acima
CREATE VIEW v_motorista_onibus
AS
SELECT CAST(codigo AS VARCHAR(10)) AS ID, nome AS nome FROM motorista
UNION
SELECT placa AS ID, marca AS nome FROM onibus

SELECT * FROM v_motorista_onibus


-- 3) Criar uma View (Chamada v_descricao_onibus) que mostre o Código da Viagem, o Nome do motorista,
-- a placa do ônibus (Formato XXX-0000), a Marca do ônibus, o Ano do ônibus e a descrição do onibus


CREATE VIEW v_descricao_onibus
AS
SELECT CONCAT(SUBSTRING(oni.placa, 1, 3), '-', SUBSTRING(oni.placa, 4, 3)) AS Placa, oni.marca AS MarcaOnibus,
	oni.ano AS AnoOnibus, oni.descricao AS DescricaoOnibus FROM viagem vi
JOIN motorista mo ON vi.motoristaCodigo = mo.codigo
	JOIN onibus oni ON vi.onibusPlaca = oni.placa

SELECT * FROM v_descricao_onibus

-- 4) Criar uma View (Chamada v_descricao_viagem) que mostre o Código da viagem, a placa do ônibus(Formato XXX-0000),
-- a Hora da Saída da viagem (Formato HH:00), a Hora da Chegada da viagem (Formato HH:00), partida e destino


CREATE VIEW v_descricao_viagem
AS
SELECT vi.codigo AS CodigoViagem, CONCAT(SUBSTRING(oni.placa, 1, 3), '-', SUBSTRING(oni.placa, 4, 3)) AS Placa,
RIGHT('0' + CAST(vi.horaSaida AS varchar(2)), 2) + ':00' AS horaSaida, RIGHT('0' + CAST(vi.horaChegada AS varchar(2)), 2) + ':00' AS horaChegada,
vi.partida AS Partida, vi.destino AS Destino FROM viagem vi
JOIN motorista mo ON vi.motoristaCodigo = mo.codigo
	JOIN onibus oni ON vi.onibusPlaca = oni.placa

SELECT * FROM v_descricao_viagem
