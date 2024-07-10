CREATE DATABASE techstore_db;

USE techstore_db;
CREATE TABLE IF NOT EXISTS tb_Categorias(
	int_idCategoria int NOT NULL AUTO_INCREMENT,
    str_nombre varchar(50) NOT NULL,
    str_descripcion varchar(100) NULL,
    bool_estado boolean NOT NULL DEFAULT 1,
    primary key (int_idCategoria)
)AUTO_INCREMENT = 1;


CREATE TABLE IF NOT EXISTS tb_Productos (
	int_idProducto int NOT NULL AUTO_INCREMENT,
    str_nombre varchar(50) NOT NULL,
    str_descripcion varchar(100) NULL,
    dou_precio float NULL,
    int_stock int NULL,
    int_idCategoria int NOT NULL,
    bool_estado boolean NOT NULL DEFAULT 1,
    PRIMARY KEY (int_idProducto),
	CONSTRAINT fk_categoria FOREIGN KEY (int_idCategoria) REFERENCES tb_Categorias(int_idCategoria)
)AUTO_INCREMENT=1; 

CREATE TABLE IF NOT EXISTS tb_Clientes(
	int_idCliente int NOT NULL AUTO_INCREMENT,
    str_nombre varchar(75) NOT NULL,
    str_correo varchar(30) NULL,
    str_telefono varchar(9) NULL,
    str_direccionEnvio varchar(100) NULL,
    bool_estado boolean NOT NULL DEFAULT 1,
    primary key (int_idCliente)
)AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS tb_Ordenes(
	int_idOrden int NOT NULL auto_increment,
    int_idCliente int NOT NULL,
    dou_total float NOT NULL DEFAULT 0,
	int_estado int NOT NULL DEFAULT 0,
    str_desestado varchar(20) NULL,
	PRIMARY KEY (int_idOrden),
    CONSTRAINT fk_cliente FOREIGN KEY (int_idCliente) REFERENCES tb_Clientes(int_idCliente)
)AUTO_INCREMENT = 1;

-- int_estado : str_desestado
-- 0 : PENDIENTE
-- 1 : ENVIADO
-- 2 : ENTREGADO
-- 3 : CANCELADO
-- 4 : ERRONEA

CREATE TABLE IF NOT EXISTS tb_Ordenes_Detalle (
    int_idOrden INT NOT NULL,
    int_idProducto INT NOT NULL,
    int_cantidad INT NULL DEFAULT 0,
    dou_precioUnit float null DEFAULT 0,
    dou_subtotal float null DEFAULT 0,
    PRIMARY KEY (int_idOrden, int_idProducto),
    CONSTRAINT fk_orden FOREIGN KEY (int_idOrden) REFERENCES tb_Ordenes(int_idOrden),
    CONSTRAINT fk_producto FOREIGN KEY (int_idProducto) REFERENCES tb_Productos(int_idProducto)
);

DELIMITER $$
CREATE PROCEDURE SP_INSERT_CATEGORIA(in nombre varchar(50), in descripcion varchar(100))
BEGIN 
	INSERT INTO tb_Categorias(str_nombre,str_descripcion) VALUES (nombre,descripcion);
END $$
DELIMITER ;