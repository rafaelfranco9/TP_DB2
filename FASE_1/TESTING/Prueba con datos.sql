

INSERT INTO recursos_humanos
VALUES
(1000),
(1001),
(1002),
(1003),
(1004),
(1005)


INSERT INTO roles (rol) 
VALUES 
('Administrador de proyecto'),
('Analista'),
('Programador'),
('Diseñador'),
('Tester'),
('Asegurador de calidad'),
('Scrum master')


INSERT INTO cliente (nombre)
VALUES
('Accenture'),
('Mercado libre'),
('Microsoft'),
('Facebook'),
('SpaceX')



INSERT INTO proyecto(id_cliente,nombre)
VALUES 
(1,'Phoenix'),
(2,'MercadoPago'),
(3,'Excel Project'),
(3,'Cloud AI'),
(5,'Falcon9')



INSERT INTO asignacion 
VALUES 
(DEFAULT,1000,6,150),
(DEFAULT,1000,7,10),
(DEFAULT,1001,7,60),
(DEFAULT,1002,8,160),
(DEFAULT,1003,9,160),
(DEFAULT,1004,10,160)



INSERT INTO participante 
VALUES 
(DEFAULT,13,'Rafael',2),
(DEFAULT,14,'Carlos',1),
(DEFAULT,15,'Jessica',3),
(DEFAULT,16,'Patricia',5),
(DEFAULT,17,'Daniel',6),
(DEFAULT,18,'Diego',7)



CALL rendir_horas_por_dia(7,'2020-07-01',8);
CALL rendir_horas_por_dia(8,'2020-11-11',10);
call rendir_horas_por_semana(8,'2020-11-09','2020-11-13',8);
CALL rendir_horas_por_mes(12,9,2020,10);
CALL Calcular_liquidacion_mensual(10,9,2020);
CALL rendir_horas_por_mes(12,9,5);
CALL Ajuste_de_horas();


SELECT * FROM centro_costos
SELECT * FROM participante
SELECT * FROM proyecto
SELECT * FROM asignacion
SELECT * FROM liquidacion
 
