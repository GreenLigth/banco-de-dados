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
idUsuario INT,
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
	CHECK (nivelAcesso > 0 AND nivelAcesso <= 3),
fkEstufa INT,
CONSTRAINT chFkEstufa
	FOREIGN KEY (fkEstufa) 
    REFERENCES estufa(idEstufa)
);

CREATE TABLE sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
codigoSensor CHAR (8),
fkEstufa INT,
CONSTRAINT chEstufa
	FOREIGN KEY (fkEstufa)
	REFERENCES estufa (idEstufa),
situacao BOOLEAN
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






