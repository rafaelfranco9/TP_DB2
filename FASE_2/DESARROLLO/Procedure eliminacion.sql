
DELIMITER $$
CREATE PROCEDURE Eliminar_registro(IN id_participante INT,IN fecha DATE)
BEGIN

	UPDATE horas_trabajadas 
	SET registro_eliminado = TRUE
	WHERE horas_trabajadas.id_participante = id_participante
	AND horas_trabajadas.fecha = fecha;

END$$
DELIMITER ;