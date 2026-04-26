CREATE DATABASE greenlight;
USE greenlight;

CREATE TABLE empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,	
CNPJ VARCHAR(14) UNIQUE NOT NULL,
representante VARCHAR (40),
fkMatriz INT, 
CONSTRAINT chMatriz
	FOREIGN KEY (fkMatriz)
    REFERENCES empresa (idEmpresa)
);

CREATE TABLE setor(
idSetor INT PRIMARY KEY AUTO_INCREMENT,
UF CHAR(2) NOT NULL,
cidade VARCHAR(30) NOT NULL,
estrada VARCHAR(30)	NOT NULL,
km VARCHAR(4),
fkEmpresa INT,
CONSTRAINT chEmpresa
	FOREIGN KEY (fkEmpresa) 
	REFERENCES empresa (idEmpresa)
);

CREATE TABLE estufa (
idEstufa INT PRIMARY KEY AUTO_INCREMENT,
nomeEstufa VARCHAR(10),
fkSetor INT,
CONSTRAINT chSetor
	FOREIGN KEY (fkSetor)
    REFERENCES setor (idSetor)
);

CREATE TABLE usuario (
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,
email VARCHAR(50) UNIQUE,
senha VARCHAR(20),
dtCadastro 	DATETIME DEFAULT CURRENT_TIMESTAMP,
fkEmpresa INT,
CONSTRAINT chFkEmpresa
	FOREIGN KEY (fkEmpresa) 
    REFERENCES empresa (idEmpresa),
statusPerfil BOOLEAN, 
nivelAcesso INT,
CONSTRAINT chAcesso
	CHECK (nivelAcesso > 0 AND nivelAcesso <= 3)
);

CREATE TABLE sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
codigoSensor CHAR (8),
fkEstufa INT,
CONSTRAINT chEstufa
	FOREIGN KEY (fkEstufa)
	REFERENCES estufa (idEstufa),
situacao BOOLEAN,
corredor VARCHAR(45),
bloco VARCHAR(10)
);

CREATE TABLE registroLuminosidade (
idRegistro INT AUTO_INCREMENT PRIMARY KEY,
luminosidade INT NOT NULL,
dataLeitura DATETIME DEFAULT NOW(),
fkSensor INT,
CONSTRAINT chFkSensor
FOREIGN KEY (fkSensor) REFERENCES sensor(idSensor)
);
INSERT INTO sensor (idSensor, codigoSensor)VALUES
(1,'E4');

SELECT * FROM registroLuminosidade;

INSERT INTO empresa (nome, CNPJ, representante, fkMatriz) VALUES
('Estufas Verdes', '11111111000100', 'Diretoria Geral', NULL),
('HortiPlus', '22222222000111', 'Bruno Martins', NULL),
('VerdeVida', '33333333000122', 'Patricia Lima', NULL),
('CampoFresco', '44444444000133', 'Eduardo Souza', NULL);

INSERT INTO setor (UF, cidade, estrada, km, fkEmpresa) VALUES
('SP', 'Mogi das Cruzes', 'Estrada das Flores', '12', 1),
('SP', 'Atibaia', 'Rodovia Dom Pedro I', '45', 1),
('MG', 'Pouso Alegre', 'BR-381', '210', 1),
('SP', 'Campinas', 'Rodovia Anhanguera', '100', 2),
('RJ', 'Teresópolis', 'Estrada Terê-Fri', '30', 3),
('PR', 'Londrina', 'PR-445', '80', 4);

INSERT INTO estufa (nomeEstufa, fkSetor) VALUES
('AlVerde', 1),
('BioFolhas', 2),
('Agroface', 3);

INSERT INTO usuario (nome, email, senha, fkEmpresa, statusPerfil, nivelAcesso) VALUES
('Administrador Geral', 'admin@estufasverdes.com', '12345678', 1, true, 3),
('Supervisor Estufas', 'supervisor@estufasverdes.com', '12345678', 1, true, 2),
('Bruno Martins', 'bruno@hortiplus.com', '12345678', 2, true, 3),
('Patricia Lima', 'patricia@verdevida.com', '12345678', 3, true, 3),
('Eduardo Souza', 'eduardo@campofresco.com', '12345678', 4, true, 3);

INSERT INTO sensor (codigoSensor, fkEstufa, situacao, corredor, bloco) VALUES
('LDR001', 7, true, 'A', '1'),
('LDR002', 8, true, 'B', '1'),
('LDR003', 8, true, 'C', '1'),
('LDR004', 8, true, 'A', '2'),
('LDR005', 9, true, 'B', '2'),
('LDR006', 9, true, 'C', '2'),
('LDR007', 9, true, 'C','2');

SELECT
	emp.nome AS empresa,
	emp.CNPJ AS cnpj,
	emp.representante AS representante,
	CONCAT(setor.cidade, ' - ', setor.UF) AS localizacao,
	CONCAT('Estrada: ', setor.estrada, ', KM ', setor.km) AS endereco,
	est.nomeEstufa AS estufa
FROM empresa AS emp
JOIN setor AS setor
	ON emp.idEmpresa = setor.fkEmpresa
JOIN estufa AS est
	ON setor.idSetor = est.fkSetor;

SELECT
	usu.nome AS usuario,
	usu.email AS email,
	emp.nome AS empresa,
	CASE
		WHEN usu.nivelAcesso = 1 THEN 'Operador'
		WHEN usu.nivelAcesso = 2 THEN 'Supervisor'
		WHEN usu.nivelAcesso = 3 THEN 'Administrador'
	END AS nivel_acesso,
	CASE
		WHEN usu.statusPerfil = true THEN 'Ativo'
		ELSE 'Inativo'
	END AS status_perfil
FROM usuario AS usu
JOIN empresa AS emp
	ON usu.fkEmpresa = emp.idEmpresa;

SELECT
	est.nomeEstufa AS estufa,
	sen.codigoSensor AS sensor,
	CONCAT('Corredor ', sen.corredor, ' - Bloco ', sen.bloco) AS local_sensor,
	CASE
		WHEN sen.situacao = true THEN 'Sensor ativo'
		ELSE 'Sensor inativo'
	END AS situacao_sensor
FROM estufa AS est
JOIN sensor AS sen
	ON est.idEstufa = sen.fkEstufa;

SELECT
	reg.dataLeitura AS data_hora,
	reg.luminosidade AS valor_lux,
	est.nomeEstufa AS estufa,
	sen.codigoSensor AS sensor,
	CONCAT('Corredor ', sen.corredor, ' - Bloco ', sen.bloco) AS local_sensor,
	CASE
		WHEN reg.luminosidade < 8000 THEN 'baixa'
		WHEN reg.luminosidade <= 30000 THEN 'ideal'
		WHEN reg.luminosidade <= 40000 THEN 'alta'
		ELSE 'muito alta'
	END AS status_luminosidade
FROM registroLuminosidade AS reg
JOIN sensor AS sen
	ON reg.fkSensor = sen.idSensor
JOIN estufa AS est
	ON sen.fkEstufa = est.idEstufa;

SELECT
	reg.dataLeitura AS data_hora,
	reg.luminosidade AS valor_lux,
	est.nomeEstufa AS estufa,
	CASE
		WHEN reg.luminosidade < 8000 THEN CONCAT('Atenção: luminosidade baixa na estufa ', est.nomeEstufa)
		WHEN reg.luminosidade > 30000 THEN CONCAT('Atenção: luminosidade alta na estufa ', est.nomeEstufa)
		ELSE CONCAT('Luminosidade ideal na estufa ', est.nomeEstufa)
	END AS mensagem_alerta
FROM registroLuminosidade AS reg
JOIN sensor AS sen
	ON reg.fkSensor = sen.idSensor
JOIN estufa AS est
	ON sen.fkEstufa = est.idEstufa;

SELECT
	emp.nome AS empresa,
	est.nomeEstufa AS estufa,
	sen.codigoSensor AS sensor,
	reg.luminosidade AS valor_lux,
	CASE
		WHEN reg.luminosidade < 8000 THEN 'Baixa luminosidade'
		WHEN reg.luminosidade <= 30000 THEN 'Luminosidade adequada'
		WHEN reg.luminosidade <= 40000 THEN 'Luminosidade alta'
		ELSE 'Luminosidade muito alta'
	END AS classificacao
FROM empresa AS emp
JOIN setor AS setor
	ON emp.idEmpresa = setor.fkEmpresa
JOIN estufa AS est
	ON setor.idSetor = est.fkSetor
JOIN sensor AS sen
	ON est.idEstufa = sen.fkEstufa
JOIN registroLuminosidade AS reg
	ON sen.idSensor = reg.fkSensor
WHERE emp.nome = 'Estufas Verdes';

SELECT * FROM estufa;





