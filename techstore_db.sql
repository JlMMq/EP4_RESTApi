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

-- CATEGORIA
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

DELIMITER $$ 
CREATE PROCEDURE SP_LIST_CATEGORIA_ACTIVO()
BEGIN
	SELECT int_idCategoria, str_nombre, str_descripcion FROM tb_categorias WHERE bool_estado = true;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SP_GET_CATEGORIA(in id int)
BEGIN 
	SELECT int_idCategoria, str_nombre, str_descripcion , bool_estado FROM tb_categorias WHERE int_idCategoria = id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SP_UPDATE_CATEGORIA(in id int, in nombre varchar(50), in descripcion varchar(100))
BEGIN
        UPDATE tb_Categorias 
        SET str_nombre = nombre, 
            str_descripcion = descripcion 
        WHERE int_idCategoria = id;   
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SP_DELT_CATEGORIA(in id int)
BEGIN
	DELETE FROM tb_Categorias WHERE int_idCategoria = id;
END $$
DELIMITER ;

-- PRODUCTO
DELIMITER $$
CREATE PROCEDURE SP_INSERT_PRODUCTO(in nombre varchar(50), in descripcion varchar(100), in precio float, in stock int, in categoria int)
BEGIN
	declare categoria_exist int default 0;
	declare cod_err int default 0;
    declare message varchar(500);
    DECLARE rows_affected INT;
    
    set message = "El producto no se pudo registrar.";
    
    SELECT 1 INTO categoria_exist  FROM tb_Categorias WHERE int_idCategoria = categoria limit 1;
    IF categoria_exist = 1  THEN
		INSERT INTO tb_Productos (str_nombre, str_descripcion, dou_precio, int_stock, int_idCategoria)
        VALUES (nombre,descripcion,precio,stock,categoria);
        SET rows_affected = ROW_COUNT();
        IF rows_affected > 0 THEN
			set cod_err = 0;
			set message = 'Producto registrado correctamente.'; 
		ELSE
			set cod_err = -1;
			set message = 'No se pudo registrar el producto.';
		END IF;
    ELSE
		set cod_err = -1;
		set message = "La categoria que se quiere asociar al producto no existe.";
    END IF;
    
    SELECT cod_err , message ;
END $$	
DELIMITER ;

DELIMITER $$ 
CREATE PROCEDURE SP_LIST_PRODUCTO_ACTIVO()
BEGIN
	SELECT p.int_idProducto, p.str_nombre, p.str_descripcion, p.dou_precio, p.int_stock, p.int_idCategoria , c.str_nombre as str_nombreCategoria 
    FROM tb_productos p  
    INNER JOIN tb_categorias c on  p.int_idCategoria = c.int_idCategoria WHERE p.bool_estado = true;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SP_GET_PRODUCTO(in id int)
BEGIN 
	SELECT p.int_idProducto, p.str_nombre, p.str_descripcion, p.dou_precio, p.int_stock, p.int_idCategoria , c.str_nombre, p.bool_estado 
    FROM tb_productos p  
    INNER JOIN tb_categorias c on  p.int_idCategoria = c.int_idCategoria WHERE p.int_idProducto = id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SP_UPDATE_PRODUCTO(in id int,in nombre varchar(50), in descripcion varchar(100), in precio float, in stock int, in categoria int)
BEGIN
	declare categoria_exist int default 0;
	declare cod_err int default 0;
    declare message varchar(500);
    DECLARE rows_affected INT;
    
    set message = "El producto no se pudo actualizar.";
    
    SELECT 1 INTO categoria_exist  FROM tb_Categorias WHERE int_idCategoria = categoria limit 1;
    IF categoria_exist = 1  THEN
		UPDATE tb_productos
        SET str_nombre = nombre,
			str_descripcion = descripcion,
            dou_precio = precio,
            int_stock = stock,
            int_idCategoria = categoria
        WHERE int_idProducto = id;
        
        SET rows_affected = ROW_COUNT();
        IF rows_affected > 0 THEN
			set cod_err = 0;
			set message = 'Producto registrado correctamente.'; 
		ELSE
			set cod_err = -1;
			set message = 'No se pudo registrar el producto.';
		END IF;
    ELSE
		set cod_err = -1;
		set message = "La categoria que se quiere asociar al producto no existe.";
    END IF;
    
    SELECT cod_err , message ;
END $$	
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SP_DELT_PRODUCTO(in id int)
BEGIN
	DELETE FROM tb_Productos WHERE int_idProducto = id;
END $$
DELIMITER ;

-- CLIENTE

-- ORDEN