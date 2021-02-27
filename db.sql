-- --------------------------------------------------------
-- Servidor:                     localhost
-- Versão do servidor:           5.7.24 - MySQL Community Server (GPL)
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para facturacion
DROP DATABASE IF EXISTS `facturacion`;
CREATE DATABASE IF NOT EXISTS `facturacion` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci */;
USE `facturacion`;

-- Copiando estrutura para procedure facturacion.actualizar_precio_producto
DROP PROCEDURE IF EXISTS `actualizar_precio_producto`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_precio_producto`(`n_cantidad` INT, `n_precio` DECIMAL(10,2), `codigo` INT)
BEGIN
    	DECLARE nueva_existencia int;
        DECLARE nuevo_total  decimal(10,2);
        DECLARE nuevo_precio decimal(10,2);
        
        DECLARE cant_actual int;
        DECLARE pre_actual decimal(10,2);
        
        DECLARE actual_existencia int;
        DECLARE actual_precio decimal(10,2);
                
        SELECT precio,existencia INTO actual_precio,actual_existencia FROM producto WHERE codproducto = codigo;
        SET nueva_existencia = actual_existencia + n_cantidad;
        SET nuevo_total = (actual_existencia * actual_precio) + (n_cantidad * n_precio);
        SET nuevo_precio = nuevo_total / nueva_existencia;
        
        UPDATE producto SET existencia = nueva_existencia, precio = nuevo_precio WHERE codproducto = codigo;
        
        SELECT nueva_existencia,nuevo_precio;
        
    END//
DELIMITER ;

-- Copiando estrutura para procedure facturacion.add_detalle_temp
DROP PROCEDURE IF EXISTS `add_detalle_temp`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_detalle_temp`(IN `codigo` INT, IN `cantidad` INT, IN `token_user` VARCHAR(50))
BEGIN
    
    	DECLARE precio_actual decimal(10,2);
        SELECT precio INTO precio_actual FROM producto WHERE codproducto = codigo;
        
        INSERT INTO detalle_temp(token_user,codproducto,cantidad,precio_venta) VALUES(token_user,codigo,cantidad,precio_actual);
        
        SELECT tmp.correlativo, tmp.codproducto,p.descripcion,tmp.cantidad,tmp.precio_venta FROM detalle_temp tmp
        INNER JOIN producto p
        ON tmp.codproducto = p.codproducto
        WHERE tmp.token_user = token_user;
        
    END//
DELIMITER ;

-- Copiando estrutura para procedure facturacion.anular_factura
DROP PROCEDURE IF EXISTS `anular_factura`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `anular_factura`(`no_factura` INT)
BEGIN
        	DECLARE existe_factura int;
            DECLARE registros int;
            DECLARE a int;
            
            DECLARE cod_producto int;
            DECLARE cant_producto int;
            DECLARE existencia_actual int;
            DECLARE nueva_existencia int;
            
            SET existe_factura = (SELECT COUNT(*) FROM factura WHERE nofactura = no_factura and estatus = 1);
            
            IF existe_factura > 0 THEN
            	CREATE TEMPORARY TABLE tbl_tmp (
                id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                cod_prod BIGINT,
                cant_prod int);
                
                SET a = 1;
                
                SET registros = (SELECT COUNT(*) FROM detallefactura WHERE nofactura = no_factura);
                
                IF registros > 0 THEN
                	
                	INSERT INTO tbl_tmp(cod_prod,cant_prod) SELECT codproducto,cantidad FROM detallefactura WHERE nofactura = no_factura;
                    
                    WHILE a <= registros DO
                    	SELECT cod_prod,cant_prod INTO cod_producto,cant_producto FROM tbl_tmp WHERE id = a;
                        SELECT existencia INTO existencia_actual FROM producto WHERE codproducto = cod_producto;
                        SET nueva_existencia = existencia_actual + cant_producto;
                        UPDATE producto SET existencia = nueva_existencia WHERE codproducto = cod_producto;
                        
                        SET a=a+1;                        
                    END WHILE;
                    
                    UPDATE factura SET estatus = 2 WHERE nofactura = no_factura;
                    DROP TABLE tbl_tmp;
                    SELECT * FROM factura WHERE nofactura = no_factura;
                
                END IF; 
            
            ELSE
            	SELECT 0 factura;
            END IF;
            
            
            
         END//
DELIMITER ;

-- Copiando estrutura para tabela facturacion.cliente
DROP TABLE IF EXISTS `cliente`;
CREATE TABLE IF NOT EXISTS `cliente` (
  `idcliente` int(11) NOT NULL AUTO_INCREMENT,
  `rfc` varchar(13) DEFAULT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  `telefono` bigint(10) DEFAULT NULL,
  `correo` varchar(100) NOT NULL,
  `direccion` text,
  `dateadd` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_id` int(11) NOT NULL,
  `estatus` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idcliente`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela facturacion.cliente: ~13 rows (aproximadamente)
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` (`idcliente`, `rfc`, `nombre`, `telefono`, `correo`, `direccion`, `dateadd`, `usuario_id`, `estatus`) VALUES
	(1, '199412568', 'Eleuterio Fulaho Notico', 860675700, 'eleuterio3d@gmail.com', 'Maputo', '2020-05-02 20:37:59', 1, 1),
	(2, 'DAVA991228CT5', 'Daniela Valladarez', 8475859685, 'danielava@gmail.com', 'Av. Nogalar 104', '2020-04-20 12:35:01', 1, 1),
	(3, 'RCMA980528ET9', 'Arely Ramirez', 8185826985, 'arelyr@gmail.com', 'San Miguel', '2020-04-20 12:36:54', 1, 1),
	(43, '12121222', 'Eleuterio Fulaho Notico', 860675700, 'eleuterio3d@gmail.com', 'Maputo', '2021-02-27 06:07:31', 1, 1);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;

-- Copiando estrutura para tabela facturacion.configuracion
DROP TABLE IF EXISTS `configuracion`;
CREATE TABLE IF NOT EXISTS `configuracion` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rfc` varchar(13) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `razon_social` varchar(100) NOT NULL,
  `telefono` bigint(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `direccion` text NOT NULL,
  `iva` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Copiando dados para a tabela facturacion.configuracion: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `configuracion` DISABLE KEYS */;
INSERT INTO `configuracion` (`id`, `rfc`, `nombre`, `razon_social`, `telefono`, `email`, `direccion`, `iva`) VALUES
	(1, '13086642578', 'SGVCR', 'venda de residuos', 860675700, 'sgvcr@gmail.com', 'Maputo Cidade,Marracuene,MoÃ§ambique', 16.00);
/*!40000 ALTER TABLE `configuracion` ENABLE KEYS */;

-- Copiando estrutura para procedure facturacion.dataDashboard
DROP PROCEDURE IF EXISTS `dataDashboard`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `dataDashboard`()
BEGIN
    	
        DECLARE usuarios int;
        DECLARE clientes int;
        DECLARE proveedores int;
        DECLARE productos int;
        DECLARE ventas int;
        
        SELECT COUNT(*) INTO usuarios FROM usuario WHERE estatus != 10;
        SELECT COUNT(*) INTO clientes FROM cliente WHERE estatus != 10;
        SELECT COUNT(*) INTO proveedores FROM proveedor WHERE estatus != 10;
        SELECT COUNT(*) INTO productos FROM producto WHERE estatus != 10;
        SELECT COUNT(*) INTO ventas FROM factura WHERE fecha > CURDATE() AND estatus != 10;
        
        SELECT usuarios,clientes,proveedores,productos,ventas;
        
    END//
DELIMITER ;

-- Copiando estrutura para procedure facturacion.del_detalle_temp
DROP PROCEDURE IF EXISTS `del_detalle_temp`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `del_detalle_temp`(IN `id_detalle` INT, IN `token` VARCHAR(50))
BEGIN
    	DELETE FROM detalle_temp WHERE correlativo = id_detalle;
        
        SELECT tmp.correlativo, tmp.codproducto, p.descripcion, tmp.cantidad, tmp.precio_venta FROM detalle_temp tmp
        INNER JOIN producto p
        ON tmp.codproducto = p.codproducto
        WHERE tmp.token_user = token;
      END//
DELIMITER ;

-- Copiando estrutura para tabela facturacion.detallefactura
DROP TABLE IF EXISTS `detallefactura`;
CREATE TABLE IF NOT EXISTS `detallefactura` (
  `correlativo` bigint(11) NOT NULL AUTO_INCREMENT,
  `nofactura` bigint(11) DEFAULT NULL,
  `codproducto` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio_venta` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`correlativo`),
  KEY `codproducto` (`codproducto`),
  KEY `nofactura` (`nofactura`),
  CONSTRAINT `detallefactura_ibfk_1` FOREIGN KEY (`nofactura`) REFERENCES `factura` (`nofactura`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `detallefactura_ibfk_2` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela facturacion.detallefactura: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `detallefactura` DISABLE KEYS */;
/*!40000 ALTER TABLE `detallefactura` ENABLE KEYS */;

-- Copiando estrutura para tabela facturacion.detalle_temp
DROP TABLE IF EXISTS `detalle_temp`;
CREATE TABLE IF NOT EXISTS `detalle_temp` (
  `correlativo` int(11) NOT NULL AUTO_INCREMENT,
  `token_user` varchar(50) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  PRIMARY KEY (`correlativo`),
  KEY `nofactura` (`token_user`),
  KEY `codproducto` (`codproducto`),
  CONSTRAINT `detalle_temp_ibfk_2` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela facturacion.detalle_temp: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `detalle_temp` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_temp` ENABLE KEYS */;

-- Copiando estrutura para tabela facturacion.entradas
DROP TABLE IF EXISTS `entradas`;
CREATE TABLE IF NOT EXISTS `entradas` (
  `correlativo` int(11) NOT NULL AUTO_INCREMENT,
  `codproducto` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cantidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  PRIMARY KEY (`correlativo`),
  KEY `codproducto` (`codproducto`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `entradas_ibfk_1` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela facturacion.entradas: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `entradas` DISABLE KEYS */;
/*!40000 ALTER TABLE `entradas` ENABLE KEYS */;

-- Copiando estrutura para tabela facturacion.factura
DROP TABLE IF EXISTS `factura`;
CREATE TABLE IF NOT EXISTS `factura` (
  `nofactura` bigint(11) NOT NULL AUTO_INCREMENT,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario` int(11) DEFAULT NULL,
  `codcliente` int(11) DEFAULT NULL,
  `totalfactura` decimal(10,2) DEFAULT NULL,
  `estatus` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`nofactura`),
  KEY `usuario` (`usuario`),
  KEY `codcliente` (`codcliente`),
  CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `factura_ibfk_2` FOREIGN KEY (`codcliente`) REFERENCES `cliente` (`idcliente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela facturacion.factura: ~29 rows (aproximadamente)
/*!40000 ALTER TABLE `factura` DISABLE KEYS */;
/*!40000 ALTER TABLE `factura` ENABLE KEYS */;

-- Copiando estrutura para procedure facturacion.procesar_venta
DROP PROCEDURE IF EXISTS `procesar_venta`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `procesar_venta`(IN `cod_usuario` INT, IN `cod_cliente` INT, IN `token` VARCHAR(50))
BEGIN
    	DECLARE factura INT;
        
        DECLARE registros INT;
        DECLARE total DECIMAL(10,2);
        
        DECLARE nueva_existencia int;
        DECLARE existencia_actual int;
        
        DECLARE tmp_cod_producto int;
        DECLARE tmp_cant_producto int;
        DECLARE a INT;
        SET a = 1;
        
        CREATE TEMPORARY TABLE tbl_tmp_tokenuser (
            id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
            cod_prod BIGINT,
            cant_prod int);
            
        SET registros = (SELECT COUNT(*) FROM detalle_temp WHERE token_user = token);
		
        IF registros > 0 THEN 
        	INSERT INTO tbl_tmp_tokenuser(cod_prod,cant_prod) SELECT codproducto,cantidad FROM detalle_temp WHERE token_user = token;
            
            INSERT INTO factura(usuario,codcliente) VALUES(cod_usuario,cod_cliente);
            SET factura = LAST_INSERT_ID();
            
            INSERT INTO detallefactura(nofactura,codproducto,cantidad,precio_venta) SELECT (factura) as nofactura, codproducto, cantidad, precio_venta FROM detalle_temp
            WHERE token_user = token;
            
            WHILE a <= registros DO
            	SELECT cod_prod,cant_prod INTO tmp_cod_producto, tmp_cant_producto FROM tbl_tmp_tokenuser WHERE id = a;
                SELECT existencia INTO existencia_actual FROM producto WHERE codproducto = tmp_cod_producto;
                
                SET nueva_existencia = existencia_actual - tmp_cant_producto;
                UPDATE producto SET existencia = nueva_existencia WHERE codproducto = tmp_cod_producto;
                
                SET a=a+1;
                
            END WHILE;
            
            SET total = (SELECT SUM(cantidad * precio_venta) FROM detalle_temp WHERE token_user = token);
            UPDATE factura SET totalfactura = total WHERE nofactura = factura;
            DELETE FROM detalle_temp WHERE token_user = token;
            TRUNCATE TABLE tbl_tmp_tokenuser;
            SELECT * FROM factura WHERE nofactura = factura;        
        ELSE
        SELECT 0;
        END IF;
END//
DELIMITER ;

-- Copiando estrutura para tabela facturacion.producto
DROP TABLE IF EXISTS `producto`;
CREATE TABLE IF NOT EXISTS `producto` (
  `codproducto` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(100) DEFAULT NULL,
  `proveedor` int(11) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `existencia` int(11) DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_id` int(11) NOT NULL,
  `estatus` int(11) NOT NULL DEFAULT '1',
  `foto` text,
  PRIMARY KEY (`codproducto`),
  KEY `proveedor` (`proveedor`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`proveedor`) REFERENCES `proveedor` (`codproveedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela facturacion.producto: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;

-- Copiando estrutura para tabela facturacion.proveedor
DROP TABLE IF EXISTS `proveedor`;
CREATE TABLE IF NOT EXISTS `proveedor` (
  `codproveedor` int(11) NOT NULL AUTO_INCREMENT,
  `proveedor` varchar(100) DEFAULT NULL,
  `contacto` varchar(100) DEFAULT NULL,
  `telefono` bigint(10) DEFAULT NULL,
  `direccion` text,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_id` int(11) NOT NULL,
  `estatus` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`codproveedor`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `proveedor_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela facturacion.proveedor: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `proveedor` DISABLE KEYS */;
INSERT INTO `proveedor` (`codproveedor`, `proveedor`, `contacto`, `telefono`, `direccion`, `date_add`, `usuario_id`, `estatus`) VALUES
	(21, 'CATIA', '9999999999', 6666666666, 'Maputo', '2021-02-27 05:39:22', 1, 1);
/*!40000 ALTER TABLE `proveedor` ENABLE KEYS */;

-- Copiando estrutura para tabela facturacion.rol
DROP TABLE IF EXISTS `rol`;
CREATE TABLE IF NOT EXISTS `rol` (
  `idrol` int(11) NOT NULL AUTO_INCREMENT,
  `rol` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`idrol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela facturacion.rol: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` (`idrol`, `rol`) VALUES
	(1, 'Administrador'),
	(2, 'Supervisor'),
	(3, 'Vendedor');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;

-- Copiando estrutura para tabela facturacion.usuario
DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `idusuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `usuario` varchar(15) DEFAULT NULL,
  `clave` varchar(100) DEFAULT NULL,
  `rol` int(11) DEFAULT NULL,
  `estatus` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idusuario`),
  KEY `rol` (`rol`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`rol`) REFERENCES `rol` (`idrol`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela facturacion.usuario: ~14 rows (aproximadamente)
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` (`idusuario`, `nombre`, `correo`, `usuario`, `clave`, `rol`, `estatus`) VALUES
	(1, 'Eduardo Banda', 'eduardo@gmail.com', 'Eduardo', '81dc9bdb52d04dc20036dbd8313ed055', 1, 1),
	(2, 'Daniela Martinez', 'danielam@gmail.com', 'daniela', '202cb962ac59075b964b07152d234b70', 3, 1),
	(3, 'Osmar Ortiz', 'osmar@gmail.com', 'osmar', '202cb962ac59075b964b07152d234b70', 2, 1),
	(4, 'Arely Robles', 'arely@gmail.com', 'arely', 'fd23073d0cfdcd1748f1fcd8d03ca903', 3, 1),
	(5, 'Daniel Morales', 'daniel@gmail.com', 'daniel', '202cb962ac59075b964b07152d234b70', 3, 1),
	(7, 'Oscar Lopez', 'oscar@gmail.com', 'oscar', '202cb962ac59075b964b07152d234b70', 3, 1),
	(8, 'Adolfo Calderon', 'adolfo@gmail.com', 'adolfo', '202cb962ac59075b964b07152d234b70', 3, 1),
	(9, 'Karina Frias', 'karina@gmail.com', 'karina', 'a0a080f42e6f13b3a2df133f073095dd', 3, 1),
	(10, 'Gustavo Sanchez', 'gustavo@gmail.com', 'gustavo', '202cb962ac59075b964b07152d234b70', 3, 0),
	(11, 'Vania Vitela', 'vania@gmail.com', 'vania', '81dc9bdb52d04dc20036dbd8313ed055', 3, 1),
	(12, 'Cesar Fraire', 'cesar@gmail.com', 'cesar', '202cb962ac59075b964b07152d234b70', 3, 1),
	(13, 'Rene Cantú', 'rene@gmail.com', 'rene', '202cb962ac59075b964b07152d234b70', 3, 1),
	(14, 'Kimberly Cantu', 'kimberly@gmail.com', 'kimberly', '202cb962ac59075b964b07152d234b70', 3, 1),
	(15, 'Roberto de Leon', 'roberto@gmail.com', 'roberto', '202cb962ac59075b964b07152d234b70', 3, 1);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;

-- Copiando estrutura para trigger facturacion.entradas_A_I
DROP TRIGGER IF EXISTS `entradas_A_I`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `entradas_A_I` AFTER INSERT ON `producto` FOR EACH ROW BEGIN
	INSERT INTO entradas(codproducto,cantidad,precio,usuario_id)
    VALUES(new.codproducto,new.existencia,new.precio,new.usuario_id);
    END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
