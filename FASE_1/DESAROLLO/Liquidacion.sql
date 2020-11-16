


DELIMITER $$
CREATE PROCEDURE Calcular_liquidacion_mensual(IN id_proyecto INT ,IN mes INT, IN anio INT)
BEGIN
	
	DECLARE f_month DATE;
	DECLARE l_month DATE;
	DECLARE exist INT DEFAULT 0;
	
	SET f_month =  date(CONCAT(anio,'-',mes,'-',1));
	SET l_month =  LAST_DAY(date(CONCAT(anio,'-',mes,'-',1)));
	
	SELECT COUNT(*) INTO exist FROM liquidacion as l
	WHERE l.id_proyecto = id_proyecto AND 
	l.mes = mes AND l.anio = anio;
	
	IF exist = 0 THEN
	
		INSERT INTO liquidacion
		SELECT pro.id_cliente,pro.id,p.id_rol,mes,anio,SUM(h.horas_cargadas)
		FROM horas_trabajadas AS h 
		INNER JOIN participante AS p ON p.id = h.id_participante
		INNER JOIN asignacion AS a ON a.id = p.id_asignacion
		INNER JOIN proyecto AS pro ON pro.id = a.id_proyecto
		WHERE h.fecha >= f_month AND h.fecha <= l_month
		AND pro.id = id_proyecto
		AND h.registro_eliminado = FALSE
		GROUP BY p.id_rol;
		
	ELSE
	
		SELECT 'YA SE LIQUIDO ESE MES, CORRA EL PROCEDURE DE AJUSTE!' AS 'MENSAJE DE ERROR!';
	
	END IF;	


END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE Ajuste_de_horas()
BEGIN
	
	
	DECLARE id_cliente INT; 
	DECLARE id_proyecto INT;
	DECLARE id_rol INT;
	DECLARE mes INT;
	DECLARE anio INT;
	DECLARE horas FLOAT;
	DECLARE horas_liquidacion FLOAT;
	DECLARE diferencia FLOAT;
	DECLARE exist INT DEFAULT 0;
	DECLARE done INT DEFAULT FALSE;
	DECLARE cursor_horas CURSOR FOR SELECT pro.id_cliente,pro.id,p.id_rol,MONTH(h.fecha),YEAR(h.fecha),SUM(h.horas_cargadas)
											  FROM horas_trabajadas AS h 
											  INNER JOIN participante AS p ON p.id = h.id_participante
											  INNER JOIN asignacion AS a ON a.id = p.id_asignacion
											  INNER JOIN proyecto AS pro ON pro.id = a.id_proyecto
											  WHERE h.fecha >= DATE(CONCAT(YEAR(CURDATE()),'-01-01')) AND h.fecha <= CURDATE()
											  GROUP BY pro.id_cliente,pro.id,p.id_rol,MONTH(h.fecha),YEAR(h.fecha);
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	OPEN cursor_horas;
	
	loopLabel: LOOP
	
		FETCH cursor_horas INTO id_cliente,id_proyecto,id_rol,mes,anio,horas;
		
		IF done THEN
			leave loopLabel;
		END IF;
		
		SELECT SUM(l.horas_cargadas) INTO horas_liquidacion FROM liquidacion AS l
		WHERE l.id_cliente = id_cliente AND 
				l.id_proyecto = id_proyecto AND 
				l.id_rol = id_rol AND 
				l.mes = mes AND 
				l.anio = anio;
		
		IF horas_liquidacion > 0 THEN
		
			SET diferencia = horas - horas_liquidacion;
				
			IF diferencia <> 0 THEN	
				
				SELECT COUNT(*) INTO exist FROM ajustes_horas_trabajadas AS aj
				WHERE aj.id_cliente = id_cliente AND 
						aj.id_proyecto = id_proyecto AND 
						aj.id_rol = id_rol AND 
						aj.mes = mes AND 
						aj.anio = anio;
				
				IF exist > 0 THEN
					
					UPDATE ajustes_horas_trabajadas
					SET ajustes_horas_trabajadas.ajuste_horas = diferencia
					WHERE ajustes_horas_trabajadas.id_cliente = id_cliente AND 
							ajustes_horas_trabajadas.id_proyecto = id_proyecto AND 
							ajustes_horas_trabajadas.id_rol = id_rol AND 
							ajustes_horas_trabajadas.mes = mes AND 
							ajustes_horas_trabajadas.anio = anio;
					
				ELSE
			 		
					 INSERT INTO ajustes_horas_trabajadas
			 		 VALUES(id_cliente,id_proyecto,id_rol,mes,anio,diferencia);
				
				END IF;
				
				SET exist = 0;
				
			END IF;
			
			SET horas_liquidacion = 0;
			SET diferencia = 0;
		   
		END IF;
		
	END LOOP;

	CLOSE cursor_horas;
	
	SELECT * FROM ajustes_horas_trabajadas;
	
END$$
DELIMITER ;

