import pool from "../db.js";

// GET todos los vehículos
export const getInventario = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM inventario ORDER BY id ASC");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Error al obtener el inventario" });
  }
};

// GET un vehículo por ID
export const getVehiculo = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM inventario WHERE id = $1", [
      id,
    ]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Vehículo no encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Error al obtener el vehículo" });
  }
};

// POST crear un vehículo
export const crearVehiculo = async (req, res) => {
  try {
    console.log("Body recibido:", req.body); // 👈 Agrega esto

    const { vin, modelo, marca, año, cantidad, ubicacion, estado } = req.body;

    const result = await pool.query(
      `INSERT INTO inventario (vin, modelo, marca, año, cantidad, ubicacion, estado)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [vin, modelo, marca, año, cantidad, ubicacion, estado]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    res
      .status(500)
      .json({ error: "Error al crear el vehículo", detalle: error.message });
  }
};

// PUT actualizar un vehículo
export const actualizarVehiculo = async (req, res) => {
  try {
    const { id } = req.params;
    const { vin, modelo, marca, año, cantidad, ubicacion, estado } = req.body;
    const result = await pool.query(
      `UPDATE inventario
       SET vin = $1, modelo = $2, marca = $3, año = $4, cantidad = $5, ubicacion = $6, estado = $7
       WHERE id = $8 RETURNING *`,
      [vin, modelo, marca, año, cantidad, ubicacion, estado, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Vehículo no encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({
      error: "Error al actualizar el vehículo",
      detalle: error.message,
    });
  }
};

// DELETE eliminar un vehículo
export const eliminarVehiculo = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "DELETE FROM inventario WHERE id = $1 RETURNING *",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Vehículo no encontrado" });
    }
    res.json({ mensaje: "Vehículo eliminado correctamente" });
  } catch (error) {
    res
      .status(500)
      .json({ error: "Error al eliminar el vehículo", detalle: error.message });
  }
};
