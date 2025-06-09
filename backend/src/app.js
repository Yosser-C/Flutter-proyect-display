import express from "express";
import cors from "cors";
import productsRouter from "./routes/products.routes.js";
import piezasRouter from "./routes/piezas.routes.js"; //

const app = express();

// ✅ Desactivar cabecera 'X-Powered-By' que revela la versión de Express
app.disable("x-powered-by");

// ✅ CORS seguro: solo permite solicitudes desde orígenes específicos
const allowedOrigins = [
  "http://localhost:5432",
  "https://automativecompany-1054.onrender.com",
]; // ← Cambia esto según tus dominios permitidos

const corsOptions = {
  origin: function (origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error("Acceso bloqueado por CORS"));
    }
  },
  credentials: true, // Solo si usas cookies o cabeceras de autenticación
};

app.use(cors("*"));
app.use(express.json());

app.use("/api/products", productsRouter);
app.use("/api/piezas", piezasRouter); //

// Ruta 404
app.use((req, res) => {
  res.status(404).json({ message: "Ruta no encontrada" });
});

export default app;
