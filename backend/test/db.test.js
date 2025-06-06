const crearTablaInventario = async (pool) => {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS inventario (
      id SERIAL PRIMARY KEY,
      vin VARCHAR(50) NOT NULL,
      modelo VARCHAR(50) NOT NULL,
      marca VARCHAR(50) NOT NULL,
      año INTEGER NOT NULL,
      cantidad INTEGER NOT NULL,
      ubicacion VARCHAR(100) NOT NULL,
      estado VARCHAR(20) NOT NULL
    );
  `);
};

const limpiarTablaInventario = async (pool) => {
  await pool.query("TRUNCATE TABLE inventario RESTART IDENTITY CASCADE");
};

module.exports = {
  crearTablaInventario,
  limpiarTablaInventario,
};
