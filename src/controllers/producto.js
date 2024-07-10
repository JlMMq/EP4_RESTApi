import {getConnection} from "./../database/database";



const insertProducto = async (req, res) =>{
    try{
        const { nombre, descripcion, precio, stock, idCategoria } = req.body;
        if(nombre === undefined || descripcion === undefined || precio === undefined || stock === undefined || idCategoria === undefined){
            res.status(400).json({"message":"Bad Request. Please fill all fields."})
        }
        const connection = await getConnection();
        const result = await connection.query("CALL SP_INSERT_PRODUCTO(?, ?, ?, ? ,?)", [nombre, descripcion, precio,stock,idCategoria]);

        if (result.length > 0) {
            const { cod_err, message } = result[0][0];
            if (cod_err === 0) {
                return res.status(200).json({ "message": message });
            } else {
                return res.status(400).json({ "message": message });
            }
        } else {
            return res.status(500).json({ "message": "Error desconocido al ejecutar el procedimiento almacenado." });
        }
    }
    catch(error){
        res.status(500);
        res.send(error.message);
    }
};

const listProducto = async (req, res)=>{

    try {
        const connection = await getConnection();
        const result = await connection.query("CALL SP_LIST_PRODUCTO_ACTIVO()");

        const productosActivos = result[0].map(producto => ({
            id: producto.int_idProducto,
            nombre: producto.str_nombre,
            descripcion: producto.str_descripcion,
            precio: producto.dou_precio,
            stock: producto.int_stock,
            idCategoria: producto.int_idCategoria,
            nombreCategoria: producto.str_nombreCategoria
        }));

        res.json(productosActivos);
    } 
    catch (error) {
        res.status(500);
        res.send(error.message);
    }
};

const getProducto = async (req, res)=>{

    try {
        const { id } = req.body;
        if(id === undefined){
            res.status(400).json({"message":"Bad Request. Please fill all fields."})
        }

        const connection = await getConnection();
        const result = await connection.query("CALL SP_GET_PRODUCTO(?)",[id]);

        const productosActivos = result[0].map(producto => ({
            id: producto.int_idProducto,
            nombre: producto.str_nombre,
            descripcion: producto.str_descripcion,
            precio: producto.dou_precio,
            stock: producto.int_stock,
            idCategoria: producto.int_idCategoria,
            nombreCategoria: producto.str_nombreCategoria,
            estado: producto.bool_estado
        }));

        res.json(productosActivos);
    } 
    catch (error) {
        res.status(500);
        res.send(error.message);
    }
};

const updateProducto = async (req, res) =>{
    try
    {
        const { id, nombre, descripcion, precio, stock, idCategoria } = req.body;
        if(id === undefined || nombre === undefined || descripcion === undefined || precio === undefined || stock === undefined || idCategoria === undefined){
            res.status(400).json({"message":"Bad Request. Please fill all fields."})
        }
        const connection = await getConnection();
        const result = await connection.query("CALL SP_INSERT_PRODUCTO(?, ?, ?, ?, ? ,?)", [id,nombre, descripcion, precio,stock,idCategoria]);

        if (result.length > 0) {
            const { cod_err, message } = result[0][0];
            if (cod_err === 0) {
                return res.status(200).json({ "message": message });
            } else {
                return res.status(400).json({ "message": message });
            }
        } else {
            return res.status(500).json({ "message": "Error desconocido al ejecutar el procedimiento almacenado." });
        }
    }
    catch(error){
        res.status(500);
        res.send(error.message);
    }
};


const deleteProducto = async (req,res) => {
    try
    {
        const {id} = req.body;
        if(id === undefined){
            res.status(400).json({"message":"Bad Request. Please fill all fields."})
        }
        const connection = await getConnection();
        const result = await connection.query("CALL SP_DELT_PRODUCTO(?)", [id]);

        if (result.affectedRows > 0) {
            res.status(200).json({ "message": "Categoria eliminada correctamente" });
        } else {
            res.status(400).json({ "message": "No se pudo eliminar la categoria o el codigo de la categoria no existe." });
        }
    }
    catch(error)
    {
        res.status(500);
        res.send(error.message);
    }
}

export const methods = {
    insertProducto,
    listProducto,
    getProducto,
    updateProducto,
    deleteProducto
};