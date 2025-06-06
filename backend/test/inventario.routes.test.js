const { expect } = require("chai");
const request = require("supertest");
const app = require("../../../src/app");
const pool = require("../../../src/db");
const {
  crearTablaInventario,
  limpiarTablaInventario,
} = require("../../helpers/dbUtils");

describe("Integration Tests: /api/inventario", () => {
  // Datos de prueba
  const vehiculoEjemplo = {
    vin: "ABC123XYZ",
    modelo: "Modelo Prueba",
    marca: "Marca Prueba",
    año: 2023,
    cantidad: 5,
    ubicacion: "Almacén Central",
    estado: "nuevo",
  };

  let vehiculoId;

  // Configuración inicial de la base de datos
  before(async () => {
    await crearTablaInventario(pool);
  });

  // Limpiar datos después de cada prueba
  afterEach(async () => {
    await limpiarTablaInventario(pool);
  });

  // Cerrar conexión a la base de datos
  after(async () => {
    await pool.end();
  });

  describe("GET /", () => {
    it("debería devolver 200 y una lista vacía cuando no hay vehículos", async () => {
      const res = await request(app).get("/api/inventario").expect(200);

      expect(res.body).to.be.an("array");
      expect(res.body).to.have.lengthOf(0);
    });

    it("debería devolver todos los vehículos existentes", async () => {
      // Insertar datos de prueba
      const insertResult = await pool.query(
        `INSERT INTO inventario (vin, modelo, marca, año, cantidad, ubicacion, estado)
         VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id`,
        [
          vehiculoEjemplo.vin,
          vehiculoEjemplo.modelo,
          vehiculoEjemplo.marca,
          vehiculoEjemplo.año,
          vehiculoEjemplo.cantidad,
          vehiculoEjemplo.ubicacion,
          vehiculoEjemplo.estado,
        ]
      );
      vehiculoId = insertResult.rows[0].id;

      const res = await request(app).get("/api/inventario").expect(200);

      expect(res.body).to.be.an("array");
      expect(res.body).to.have.lengthOf(1);
      expect(res.body[0]).to.include(vehiculoEjemplo);
    });
  });

  describe("GET /:id", () => {
    it("debería devolver un vehículo específico por ID", async () => {
      // Insertar datos de prueba
      const insertResult = await pool.query(
        `INSERT INTO inventario (vin, modelo, marca, año, cantidad, ubicacion, estado)
         VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id`,
        [
          vehiculoEjemplo.vin,
          vehiculoEjemplo.modelo,
          vehiculoEjemplo.marca,
          vehiculoEjemplo.año,
          vehiculoEjemplo.cantidad,
          vehiculoEjemplo.ubicacion,
          vehiculoEjemplo.estado,
        ]
      );
      vehiculoId = insertResult.rows[0].id;

      const res = await request(app)
        .get(`/api/inventario/${vehiculoId}`)
        .expect(200);

      expect(res.body).to.be.an("object");
      expect(res.body).to.include(vehiculoEjemplo);
      expect(res.body.id).to.equal(vehiculoId);
    });

    it("debería devolver 404 para un ID inexistente", async () => {
      const res = await request(app).get("/api/inventario/999999").expect(404);

      expect(res.body).to.have.property("error", "Vehículo no encontrado");
    });

    it("debería devolver 400 para un ID inválido", async () => {
      const res = await request(app).get("/api/inventario/abc123").expect(500); // O 400 si tienes validación de ID en el middleware
    });
  });

  describe("POST /", () => {
    it("debería crear un nuevo vehículo", async () => {
      const res = await request(app)
        .post("/api/inventario")
        .send(vehiculoEjemplo)
        .expect(201);

      expect(res.body).to.be.an("object");
      expect(res.body).to.include(vehiculoEjemplo);
      expect(res.body.id).to.be.a("number");

      // Verificar en la base de datos
      const dbResult = await pool.query(
        "SELECT * FROM inventario WHERE id = $1",
        [res.body.id]
      );
      expect(dbResult.rows[0]).to.deep.include(vehiculoEjemplo);
    });

    it("debería fallar si faltan campos requeridos", async () => {
      const vehiculoIncompleto = { ...vehiculoEjemplo };
      delete vehiculoIncompleto.vin;

      const res = await request(app)
        .post("/api/inventario")
        .send(vehiculoIncompleto)
        .expect(500);

      expect(res.body).to.have.property("error", "Error al crear el vehículo");
      expect(res.body.detalle).to.include("null value in column");
    });

    it("debería fallar con datos inválidos", async () => {
      const res = await request(app)
        .post("/api/inventario")
        .send({ ...vehiculoEjemplo, año: "no-es-un-numero" })
        .expect(500);

      expect(res.body).to.have.property("error", "Error al crear el vehículo");
    });
  });

  describe("PUT /:id", () => {
    beforeEach(async () => {
      // Insertar datos de prueba antes de cada test PUT
      const insertResult = await pool.query(
        `INSERT INTO inventario (vin, modelo, marca, año, cantidad, ubicacion, estado)
         VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id`,
        [
          vehiculoEjemplo.vin,
          vehiculoEjemplo.modelo,
          vehiculoEjemplo.marca,
          vehiculoEjemplo.año,
          vehiculoEjemplo.cantidad,
          vehiculoEjemplo.ubicacion,
          vehiculoEjemplo.estado,
        ]
      );
      vehiculoId = insertResult.rows[0].id;
    });

    it("debería actualizar un vehículo existente", async () => {
      const datosActualizados = {
        ...vehiculoEjemplo,
        modelo: "Modelo Actualizado",
        cantidad: 10,
      };

      const res = await request(app)
        .put(`/api/inventario/${vehiculoId}`)
        .send(datosActualizados)
        .expect(200);

      expect(res.body).to.include(datosActualizados);

      // Verificar en la base de datos
      const dbResult = await pool.query(
        "SELECT * FROM inventario WHERE id = $1",
        [vehiculoId]
      );
      expect(dbResult.rows[0].modelo).to.equal("Modelo Actualizado");
      expect(dbResult.rows[0].cantidad).to.equal(10);
    });

    it("debería devolver 404 al actualizar un ID inexistente", async () => {
      const res = await request(app)
        .put("/api/inventario/999999")
        .send(vehiculoEjemplo)
        .expect(404);

      expect(res.body).to.have.property("error", "Vehículo no encontrado");
    });

    it("debería manejar datos inválidos en actualización", async () => {
      const res = await request(app)
        .put(`/api/inventario/${vehiculoId}`)
        .send({ ...vehiculoEjemplo, año: "no-es-un-numero" })
        .expect(500);

      expect(res.body).to.have.property(
        "error",
        "Error al actualizar el vehículo"
      );
    });
  });

  describe("DELETE /:id", () => {
    beforeEach(async () => {
      // Insertar datos de prueba antes de cada test DELETE
      const insertResult = await pool.query(
        `INSERT INTO inventario (vin, modelo, marca, año, cantidad, ubicacion, estado)
         VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id`,
        [
          vehiculoEjemplo.vin,
          vehiculoEjemplo.modelo,
          vehiculoEjemplo.marca,
          vehiculoEjemplo.año,
          vehiculoEjemplo.cantidad,
          vehiculoEjemplo.ubicacion,
          vehiculoEjemplo.estado,
        ]
      );
      vehiculoId = insertResult.rows[0].id;
    });

    it("debería eliminar un vehículo existente", async () => {
      const res = await request(app)
        .delete(`/api/inventario/${vehiculoId}`)
        .expect(200);

      expect(res.body).to.have.property(
        "mensaje",
        "Vehículo eliminado correctamente"
      );

      // Verificar que ya no existe en la base de datos
      const dbResult = await pool.query(
        "SELECT * FROM inventario WHERE id = $1",
        [vehiculoId]
      );
      expect(dbResult.rows).to.have.lengthOf(0);
    });

    it("debería devolver 404 al eliminar un ID inexistente", async () => {
      const res = await request(app)
        .delete("/api/inventario/999999")
        .expect(404);

      expect(res.body).to.have.property("error", "Vehículo no encontrado");
    });
  });
});
