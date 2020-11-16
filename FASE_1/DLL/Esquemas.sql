CREATE DATABASE trabajo_Practico;
USE trabajo_Practico;


CREATE TABLE Recursos_Humanos (
	
	legajo INT PRIMARY KEY NOT NULL
);


CREATE TABLE Roles (

	id INT PRIMARY KEY AUTO_INCREMENT, 
	rol VARCHAR(255) NOT NULL 
);


CREATE TABLE Cliente (

	id INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(255)
);



CREATE TABLE Proyecto (

	id INT PRIMARY KEY AUTO_INCREMENT,
	id_cliente INT,
	nombre VARCHAR(255),
	FOREIGN KEY(id_cliente) REFERENCES Cliente(id) 
);



CREATE TABLE Centro_Costos (
	
	id_cliente INT,
	id_proyecto INT, 
	horas_cargadas FLOAT,
	FOREIGN KEY(id_cliente) REFERENCES Cliente(id),
	FOREIGN KEY(id_proyecto) REFERENCES Proyecto(id),
	PRIMARY KEY (id_cliente,id_proyecto)
);

CREATE TABLE Centro_Facturacion (

	id_cliente INT,
	id_proyecto INT,
	horas_facturadas FLOAT,
	FOREIGN KEY(id_cliente) REFERENCES Cliente(id),
	FOREIGN KEY(id_proyecto) REFERENCES Proyecto(id),
	PRIMARY KEY (id_cliente,id_proyecto)
);



CREATE TABLE Asignacion (
	
	id INT PRIMARY KEY AUTO_INCREMENT, 
	legajo INT, 
	id_proyecto INT, 
	horas_mensuales FLOAT, 
	FOREIGN KEY (legajo) REFERENCES Recursos_Humanos(legajo),
	FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id),
   UNIQUE(legajo,id_proyecto)

);



CREATE TABLE Participante (
	
	id INT PRIMARY KEY AUTO_INCREMENT,
	id_asignacion INT UNIQUE,
	nombre VARCHAR(100) NOT NULL,
	id_rol INT,
	FOREIGN KEY(id_asignacion) REFERENCES asignacion(id),
	FOREIGN KEY(id_rol) REFERENCES Roles(id)
);



CREATE TABLE Horas_Trabajadas (

	id_participante INT,
	fecha DATE,
	horas_cargadas FLOAT,
	FOREIGN KEY(id_participante) REFERENCES participante(id)	

);



CREATE TABLE liquidacion (
	
	id_cliente INT,
	id_proyecto INT,
	id_rol INT,
	mes INT,
	anio INT,  
	horas_cargadas FLOAT,
	FOREIGN KEY (id_cliente) REFERENCES cliente(id),
	FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id),
	FOREIGN KEY(id_rol) REFERENCES Roles(id),
	PRIMARY KEY(id_cliente,id_proyecto,id_rol)
);


CREATE TABLE ajustes_horas_trabajadas (
	
	id_cliente INT,
	id_proyecto INT,
	id_rol INT,
	mes INT,
	anio INT,  
	ajuste_horas FLOAT,
	FOREIGN KEY (id_cliente) REFERENCES cliente(id),
	FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id),
	FOREIGN KEY(id_rol) REFERENCES Roles(id),
	PRIMARY KEY(id_cliente,id_proyecto,id_rol)
);

