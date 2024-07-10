import {getConnection} from "./../database/database";

const insertOrden = async (req, res) => {
    const connection = await getConnection();

    try {
        const { idCliente, detalle } = req.body;

        if (!idCliente || !detalle || !Array.isArray(detalle) || detalle.length === 0) {
            return res.status(400).json({ "message": "Bad Request. Please fill all fields." });
        }

        await connection.beginTransaction(); 

        const orderResult = await connection.query("CALL SP_INSERT_ORDEN_CAB(?)", [idCliente]);
        const { cod_err: codErrOrder, message: messageOrder, out_id: idOrden } = orderResult[0][0];

        if (codErrOrder !== 1) {
            await connection.rollback();
            return res.status(400).json({ "message": messageOrder });
        }

        for (let item of detalle) {
            const { idProducto, cantidad } = item;
            const detailResult = await connection.query("CALL SP_INSERT_ORDEN_DETLL(?, ?, ?)", [idOrden, idProducto, cantidad]);
            const { cod_err: codErrDetail, message: messageDetail } = detailResult[0][0];

            if (codErrDetail !== 1) {
                await connection.rollback();
                return res.status(400).json({ "message": messageDetail });
            }
        }

        await connection.commit(); 
        res.status(200).json({ "message": "Orden registrada correctamente." });
    } 
    catch (error) 
    {
        await connection.rollback();
        res.status(500).send(error.message);
    } 
};


export const methods = {
    insertOrden,
};