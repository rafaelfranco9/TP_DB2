


DELIMITER $$

CREATE PROCEDURE rendir_horas_por_dia(IN id_participante INT,IN fecha DATE,IN horas FLOAT)
BEGIN 

	DECLARE EXIST INT DEFAULT 0;
	DECLARE participante_valido INT DEFAULT 0;
	
	SELECT COUNT(*) INTO participante_valido FROM participante AS p WHERE p.id = id_participante; 
	
	IF participante_valido > 0 THEN 
		
			SELECT COUNT(*) INTO EXIST FROM Horas_Trabajadas AS h 
					  WHERE h.id_participante = id_participante AND
					  		  h.fecha = fecha;	
								 		
			
			IF EXIST > 0 THEN
				
				UPDATE Horas_Trabajadas
				SET horas_cargadas = horas
			   WHERE Horas_Trabajadas.id_participante = id_participante AND
			  		   Horas_Trabajadas.fecha = fecha;
			  		   
			ELSE 
			
				INSERT INTO Horas_Trabajadas
				VALUES(id_participante,fecha,horas,FALSE);
		
			END IF;
	
	ELSE 
		SELECT 'EL PARTICIPANTE ES INVALIDO' AS 'MENSAJE DE ERROR';
	END IF;
	
END$$

DELIMITER ;  






DELIMITER $$

CREATE PROCEDURE rendir_horas_por_semana(IN id_participante INT,
													  IN fecha_desde DATE,
													  IN fecha_hasta DATE,
													  IN horas FLOAT)  
BEGIN 

	DECLARE EXIST INT DEFAULT 0;
	DECLARE participante_valido INT DEFAULT 0;
	
	SELECT COUNT(*) INTO participante_valido FROM participante AS p WHERE p.id = id_participante;

	IF participante_valido > 0 THEN 
	
		IF WEEKDAY(fecha_desde) = 0 AND WEEKDAY(fecha_hasta) = 4 AND DATEDIFF(fecha_hasta,fecha_desde) = 4 THEN
			
			
			SET fecha_hasta = ADDDATE(fecha_hasta,INTERVAL 1 DAY);
			WHILE fecha_desde <> fecha_hasta DO
			
			   CALL rendir_horas_por_dia(id_participante,fecha_desde,horas);
				SET fecha_desde = ADDDATE(fecha_desde,INTERVAL 1 DAY);
			
			END WHILE;
	
	
		ELSE
		  SELECT 'SEMANA INVALIDA' AS 'MENSAJE DE ERROR';
		END IF;	
	
	ELSE 
		SELECT 'EL PARTICIPANTE ES INVALIDO' AS 'MENSAJE DE ERROR';
	END IF;

END$$

DELIMITER ;




DELIMITER $$

CREATE PROCEDURE rendir_horas_por_mes(IN id_participante INT,
													  IN mes INT,
													  IN anio INT,
													  IN horas FLOAT)  
BEGIN 

	DECLARE EXIST INT DEFAULT 0;
	DECLARE participante_valido INT DEFAULT 0;
	DECLARE f_month DATE;
	DECLARE l_month DATE;
		
	SELECT COUNT(*) INTO participante_valido FROM participante AS p WHERE p.id = id_participante;

	IF participante_valido > 0 THEN 		
		
		IF mes >=1 AND mes <=12 THEN
			
			SET f_month =  date(CONCAT(anio,'-',mes,'-',1));
			SET l_month =  LAST_DAY(date(CONCAT(anio,'-',mes,'-',1)));
			
			SET l_month = ADDDATE(l_month,INTERVAL 1 DAY);
			WHILE f_month <> l_month DO
			
			   CALL rendir_horas_por_dia(id_participante,f_month,horas);
				SET f_month = ADDDATE(f_month,INTERVAL 1 DAY);
			
			END WHILE;
	
	
		ELSE
		  SELECT 'MES INVALIDO' AS 'MENSAJE DE ERROR';
		END IF;	
	
	ELSE 
		SELECT 'EL PARTICIPANTE ES INVALIDO' AS 'MENSAJE DE ERROR';
	END IF;

END$$

DELIMITER ;




DELIMITER $$

CREATE TRIGGER Actualizar_Centro_Costos AFTER UPDATE ON Horas_Trabajadas FOR EACH ROW 
BEGIN 
		
		DECLARE proyecto INT;
		DECLARE cliente INT; 
		
		SELECT pro.id INTO proyecto FROM participante AS p
		INNER JOIN asignacion AS a ON a.id = p.id_asignacion
		INNER JOIN proyecto AS pro ON pro.id = a.id_proyecto
		WHERE p.id = OLD.id_participante;
		
		SELECT pro.id_cliente INTO cliente FROM participante AS p
		INNER JOIN asignacion AS a ON a.id = p.id_asignacion
		INNER JOIN proyecto AS pro ON pro.id = a.id_proyecto
		WHERE p.id = OLD.id_participante;
		
		
		UPDATE Centro_Costos
		SET horas_cargadas = horas_cargadas + (NEW.horas_cargadas - OLD.horas_cargadas)
		WHERE centro_costos.id_cliente = cliente AND 
				centro_costos.id_proyecto = proyecto;	

END$$

DELIMITER ;




DELIMITER $$

CREATE TRIGGER Insertar_Centro_Costos AFTER INSERT ON Horas_Trabajadas FOR EACH ROW 
BEGIN 

		DECLARE proyecto INT;
		DECLARE cliente INT; 
		
		SELECT pro.id INTO proyecto FROM participante AS p
		INNER JOIN asignacion AS a ON a.id = p.id_asignacion
		INNER JOIN proyecto AS pro ON pro.id = a.id_proyecto
		WHERE p.id = NEW.id_participante;
		
		SELECT pro.id_cliente INTO cliente FROM participante AS p
		INNER JOIN asignacion AS a ON a.id = p.id_asignacion
		INNER JOIN proyecto AS pro ON pro.id = a.id_proyecto
		WHERE p.id = NEW.id_participante;
		
		UPDATE Centro_Costos
		SET horas_cargadas = horas_cargadas + NEW.horas_cargadas
		WHERE centro_costos.id_cliente = cliente AND 
				centro_costos.id_proyecto = proyecto;	

END$$

DELIMITER ;


	