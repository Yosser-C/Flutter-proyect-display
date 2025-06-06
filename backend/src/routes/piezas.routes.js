import { Router } from "express";
import { getPiezas } from "../controllers/piezas.controller.js";

const router = Router();

router.get("/", getPiezas);

export default router;
