import pool from "../db.js"; // Asegúrate de que este path sea correcto

// Obtener todas las piezas disponibles
export const getPiezas = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM piezas");
    res.json(result.rows); // PostgreSQL usa `rows` directamente
  } catch (error) {
    console.error("Error al obtener piezas:", error);
    res.status(500).json({ error: "Error al obtener piezas" });
  }
};

// (Opcional) Obtener una pieza por ID
export const getPiezaPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM piezas WHERE id = $1", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Pieza no encontrada" });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error al obtener pieza:", error);
    res.status(500).json({ error: "Error al obtener la pieza" });
  }
};
