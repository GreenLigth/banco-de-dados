/* 
Esther Nascimento Dos Santos
Julia Santos da Silva
Luiza da Rocha Moreno
Mariana Araujo da Silva
Nicole Cristina da Silva
Thamyres da Silva Batista
*/

CREATE DATABASE greenlight;
USE greenlight;

CREATE TABLE empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,	
CNPJ VARCHAR(14) UNIQUE NOT NULL,
email VARCHAR(50) UNIQUE NOT NULL,
senha VARCHAR(20) NOT NULL,
dtCadastro DATETIME DEFAULT NOW(),
representante VARCHAR (40)
);

CREATE TABLE Setor(
idSetor INT PRIMARY KEY AUTO_INCREMENT,
UF CHAR(2) NOT NULL,
cidade VARCHAR(30) NOT NULL,
estrada VARCHAR(30)	NOT NULL,
km VARCHAR(4),
fkEmpresa INT,
FOREIGN KEY (fkEmpresa) REFERENCES empresa (idEmpresa)
);

CREATE TABLE usuario (
idUsuario INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
email VARCHAR(50) UNIQUE,
senha VARCHAR(20),
dtCadastro 	DATETIME DEFAULT CURRENT_TIMESTAMP,
fkEmpresa INT,
CONSTRAINT
	FOREIGN KEY (fkEmpresa) 
    REFERENCES empresa (idEmpresa)
);

CREATE TABLE estufa (
idEstufa INT PRIMARY KEY AUTO_INCREMENT,
nomeEstufa VARCHAR(10),
capacidade INT,
	CONSTRAINT chk_capacidade_estufa
	CHECK (capacidade > 0),
fkEmpresa INT,
	CONSTRAINT
    FOREIGN KEY (fkEmpresa) 
    REFERENCES greenlight.empresa (idEmpresa),
fkSetor INT,
CONSTRAINT 
	FOREIGN KEY (fkSetor) 
    REFERENCES greenlight.setor (idSetor)

);

CREATE TABLE sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
codigoSensor CHAR (8),
fkEstufa INT,
CONSTRAINT 
	FOREIGN KEY (fkEstufa)
	REFERENCES greenlight.estufa(idEstufa),
situacao VARCHAR (20),
CONSTRAINT chSensor CHECK (situacao IN('Inativo','ativo', 'Em manutenção'))
);

CREATE TABLE registroLuminosidade (
idRegistro INT AUTO_INCREMENT PRIMARY KEY,
luminosidade INT NOT NULL,
	CONSTRAINT chk_luminosidade_registro 
	    CHECK (luminosidade >= 0),
dataLeitura DATETIME DEFAULT NOW()
);

CREATE TABLE alerta (
idAlerta INT PRIMARY KEY AUTO_INCREMENT, 
tipo VARCHAR (20),
CONSTRAINT chAlerta CHECK (tipo IN ('Luminosidade muito alta', 'Luminosidade muito baixa')),
fkSensor INT, 
CONSTRAINT 
	FOREIGN KEY (fkSensor) 
    REFERENCES greenlight.sensor (idSensor),
qtdLumi INT NOT NULL,
	CONSTRAINT chk_luminosidade_registro 
	    CHECK (qtdLumi IN (qtdLumi >1000 AND qtdLumi < 200))

);

CREATE TABLE producao (
idProducao INT AUTO_INCREMENT PRIMARY KEY,
quantidadeProduzida INT NOT NULL,
	CONSTRAINT chk_quantidade_produzida 
		CHECK (quantidadeProduzida >= 0),
quantidadePerdida INT NOT NULL,
    CONSTRAINT chk_quantidade_perdida 
	  CHECK (quantidadePerdida >= 0),
dtProducao DATETIME DEFAULT CURRENT_TIMESTAMP
);
