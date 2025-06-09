import pkg from "pg";
const { Client } = pkg;

const connectionString =
  process.env.TEST_DATABASE_URL ||
  "postgres://postgres:Platon12%40@localhost:5432/postgres";

describe("DB Inventario", () => {
  let client;

  before(async () => {
    client = new Client({ connectionString });
    await client.connect();
  });

  after(async () => {
    await client.end();
  });

  it("La tabla inventario debe existir", async () => {
    const res = await client.query(
      "SELECT to_regclass('inventario') as existe"
    );
    if (!res.rows[0].existe) throw new Error("La tabla inventario NO existe");
  });

  it("Debe insertar y leer un registro en inventario", async () => {
    const vin = "VINTEST123456789";
    await client.query(
      `INSERT INTO inventario (vin, modelo, marca, año, cantidad, ubicacion, estado)
       VALUES ($1, $2, $3, $4, $5, $6, $7)`,
      [vin, "TestModelo", "TestMarca", 2024, 1, "TestUbicacion", "Disponible"]
    );
    const res = await client.query("SELECT * FROM inventario WHERE vin = $1", [
      vin,
    ]);
    if (res.rows.length !== 1) throw new Error("No se insertó el registro");
    // Limpieza
    await client.query("DELETE FROM inventario WHERE vin = $1", [vin]);
  });
});
