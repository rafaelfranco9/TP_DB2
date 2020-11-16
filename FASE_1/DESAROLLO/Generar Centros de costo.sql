


DELIMITER $$
CREATE TRIGGER Generar_centros AFTER INSERT ON proyecto FOR EACH ROW 
BEGIN 

	INSERT INTO centro_costos
	VALUES (NEW.id_cliente,NEW.id,0);
	
	INSERT INTO centro_facturacion
	VALUES (NEW.id_cliente,NEW.id,0);

END$$

DELIMITER ;




