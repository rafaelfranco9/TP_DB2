
DELIMITER $$
CREATE TRIGGER auditoria_de_horas AFTER UPDATE ON Horas_Trabajadas FOR EACH ROW 
BEGIN 
		
	INSERT INTO auditoria_horas_cargadas
	VALUES(CURRENT_USER(),NOW(),OLD.fecha,OLD.horas_cargadas,NEW.horas_cargadas);

END$$
DELIMITER ;


