import express from "express";
import morgan from "morgan"
import cat from "./routes/categoria.routes";
import cors from "cors";

const app = express();

app.set("port",4000);

app.use(morgan("dev"));
app.use(express.json());
app.use(cors());

app.use(cat);

export default app;
