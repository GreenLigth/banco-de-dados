/* 
Esther Nascimento Dos Santos
Julia Santos da Silva(dev)
Luiza da Rocha Moreno
Max Araujo da Silva (dev)
Nicole Cristina da Silva
Thamyres da Silva Batista
*/

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

CREATE TABLE Setor(
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

CREATE TABLE usuario (
idUsuario INT,
nome VARCHAR(50) NOT NULL,
email VARCHAR(50) UNIQUE,
senha VARCHAR(20),
dtCadastro 	DATETIME DEFAULT CURRENT_TIMESTAMP,
fkEmpresa INT PRIMARY KEY,
CONSTRAINT
	FOREIGN KEY (fkEmpresa) 
    REFERENCES empresa (idEmpresa),
statusPerfil TINYINT, 
CONSTRAINT chStatus 
	CHECK (statusPerfil (statusPerfil = 0 AND statusPerfil = 1)),
nivelAcesso INT,
CONSTRAINT chAcesso
	CHECK (nivelAcesso > 0 AND nivelAcesso <= 3)
);

CREATE TABLE estufa (
idEstufa INT PRIMARY KEY AUTO_INCREMENT,
nomeEstufa VARCHAR(10),
capacidade INT,
	CONSTRAINT chk_capacidade_estufa
	CHECK (capacidade > 0),
fkSetor INT,
CONSTRAINT chSetor
	FOREIGN KEY (fkSetor)
    REFERENCES setor (idSetor)

);

CREATE TABLE sensor (
idSensor INT,
codigoSensor CHAR (8),
fkEstufa INT PRIMARY KEY,
CONSTRAINT chEstufa
	FOREIGN KEY (fkEstufa)
	REFERENCES estufa (idEstufa),
situacao VARCHAR (20),
CONSTRAINT chSensor CHECK (situacao IN('Inativo','ativo', 'Em manutenção'))
);

CREATE TABLE registroLuminosidade (
idRegistro INT AUTO_INCREMENT PRIMARY KEY,
luminosidade INT NOT NULL,
	CONSTRAINT chk_luminosidade_registro 
	    CHECK (luminosidade >= 0),
dataLeitura DATETIME DEFAULT NOW(),
<<<<<<< HEAD
fkEstufa INT,
=======
fkSensor INT, 
CONSTRAINT 
	FOREIGN KEY (fkSensor) 
    REFERENCES greenlight.sensor (idSensor)
	
);

CREATE TABLE alerta (
idAlerta INT PRIMARY KEY AUTO_INCREMENT, 
tipo VARCHAR (20),
CONSTRAINT chAlerta CHECK (tipo IN ('Luminosidade muito alta', 'Luminosidade muito baixa')),
fkSensor INT, 
>>>>>>> e2c9ced0aabbb0b8478d0f642c6d718a89c41639
CONSTRAINT 
	FOREIGN KEY (fkEstufa)
	REFERENCES greenlight.estufa(idEstufa),
alerta VARCHAR (20),
CONSTRAINT chAlerta CHECK (alerta IN ('Luminosidade muito alta', 'Luminosidade muito baixa', 'Normal')),
qtdLumi INT NOT NULL,
<<<<<<< HEAD
	CONSTRAINT chk_luminosidade_alerta
	    CHECK (qtdLumi IN (qtdLumi >1000 AND qtdLumi < 200))
=======
	CONSTRAINT chk_luminosidade_registro 
	    CHECK (qtdLumi IN (qtdLumi >1000 AND qtdLumi < 200)),, 
CONSTRAINT 
		FOREIGN KEY (qtdLumi)
		REFERENCES greenlitgh.registroLuminosidade (luminosidade)

>>>>>>> e2c9ced0aabbb0b8478d0f642c6d718a89c41639
);

CREATE TABLE producao (
idProducao INT,
quantidadeProduzida INT NOT NULL,
	CONSTRAINT chk_quantidade_produzida 
		CHECK (quantidadeProduzida >= 0),
quantidadePerdida INT NOT NULL,
    CONSTRAINT chk_quantidade_perdida 
	  CHECK (quantidadePerdida >= 0),
dtProducao DATETIME DEFAULT CURRENT_TIMESTAMP,
<<<<<<< HEAD
fkSetor INT PRIMARY KEY,
CONSTRAINT ch_Setor
	FOREIGN KEY (fkSetor)
    REFERENCES greenlight.setor (idSetor) 
=======
fkSetor INT, 
CONSTRAINT
	FOREIGN KEY (fkSetor) 
	REFERENCES greenlight.setor (idSetor)
>>>>>>> e2c9ced0aabbb0b8478d0f642c6d718a89c41639
);

DROP DATABASE greenlight;
