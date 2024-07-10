import {getConnection} from "./../database/database"
import {Router} from "express"
import {methods as ordenController} from "./../controllers/orden";

const router = Router();

router.post("/api/orden",ordenController.insertOrden);

export default router;