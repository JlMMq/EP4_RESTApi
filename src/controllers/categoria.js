import {getConnection} from "./../database/database";
import bcrypt from "bcryptjs";

const insertCategoria = async (req, res) =>{
    try{
        const { nombre, descripcion } = req.body;
        if(nombre === undefined || descripcion === undefined){
            res.status(400).json({"message":"Bad Request. Please fill all fields."})
        }
        const connection = await getConnection();
        const result = await connection.query("CALL SP_INSERT_CATEGORIA(?, ?)", [nombre, descripcion]);

        if (result.affectedRows > 0) {
            res.json({ "message": "Categoria registrada correctamente" });
        } else {
            res.status(400).json({ "message": "No se pudo registrar la categoria" });
        }
    }
    catch(error){
        res.status(500);
        res.send(error.message);
    }
};

export const methods = {
    insertCategoria
};