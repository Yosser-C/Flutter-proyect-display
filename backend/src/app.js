import express from "express";
import cors from "cors";
import productsRouter from "./routes/products.routes.js";
import piezasRouter from "./routes/piezas.routes.js"; //

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/products", productsRouter);
app.use("/api/piezas", piezasRouter); //

// Ruta 404
app.use((req, res) => {
  res.status(404).json({ message: "Ruta no encontrada" });
});

export default app;
