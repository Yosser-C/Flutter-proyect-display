import { Router } from "express";
import {
  getInventario,
  getVehiculo,
  crearVehiculo,
  actualizarVehiculo,
  eliminarVehiculo,
} from "../controllers/inventario.controller.js";

const router = Router();

router.get("/", getInventario);
router.get("/:id", getVehiculo);
router.post("/", crearVehiculo);
router.put("/:id", actualizarVehiculo);
router.delete("/:id", eliminarVehiculo);

export default router;
