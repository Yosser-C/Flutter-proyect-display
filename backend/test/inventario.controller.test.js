import { Client } from "pg";

const connectionString =
  process.env.TEST_DATABASE_URL ||
  "postgres://postgres:Platon12%40@localhost:5432/postgres";

async function main() {
  const client = new Client({ connectionString });
  await client.connect();

  try {
    // Test 1: Verificar que la tabla existe
    const res1 = await client.query(
      "SELECT to_regclass('inventario') as existe"
    );
    if (!res1.rows[0].existe) {
      console.error("❌ La tabla inventario NO existe");
    } else {
      console.log("✅ La tabla inventario existe");
    }

    // Test 2: Insertar y leer un registro
    const vin = "VINTEST123456789";
    await client.query(
      `INSERT INTO inventario (vin, modelo, marca, año, cantidad, ubicacion, estado)
       VALUES ($1, $2, $3, $4, $5, $6, $7)`,
      [vin, "TestModelo", "TestMarca", 2024, 1, "TestUbicacion", "Disponible"]
    );
    const res2 = await client.query("SELECT * FROM inventario WHERE vin = $1", [
      vin,
    ]);
    if (res2.rows.length !== 1) {
      console.error("❌ No se insertó el registro");
    } else {
      console.log("✅ Registro insertado y leído correctamente");
    }
    // Limpieza
    await client.query("DELETE FROM inventario WHERE vin = $1", [vin]);
  } catch (err) {
    console.error("❌ Error:", err.message);
  } finally {
    await client.end();
  }
}

main();
