

CREATE USER 'auditor'@'%' IDENTIFIED BY '123456';
CREATE USER 'administrador'@'%' IDENTIFIED BY '123456';
CREATE USER 'sitio_web'@'%' IDENTIFIED BY '123456';
CREATE USER 'sitio_web_revisor'@'%' IDENTIFIED BY '123456';

GRANT SELECT ON trabajo_practico.* TO 'auditor'@'%';
GRANT INSERT, CREATE, ALTER ON trabajo_practico.* TO 'administrador'@'%';
GRANT SELECT ,INSERT ON trabajo_practico.* TO 'sitio_web'@'%';
GRANT INSERT,UPDATE,EXECUTE ON trabajo_practico.* TO 'sitio_web_revisor'@'%';

--GRANT EXECUTE ON PROCEDURE `trabajo_practico`.`Eliminar_registro` TO 'sitio_web_revisor'@'%';

REVOKE ALL ON trabajo_practico.* from 'sitio_web_revisor'@'%';
SHOW GRANTS FOR 'sitio_web_revisor'@'%';