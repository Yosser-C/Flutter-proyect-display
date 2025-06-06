const { expect } = require("chai");
const sinon = require("sinon");
const inventarioController = require("../../../src/controllers/inventario.controller");
const pool = require("../../../src/db"); // Importamos pool para simularlo

describe("Unit Tests: inventario.controller", () => {
  let sandbox;
  let mockPoolQuery;

  beforeEach(() => {
    sandbox = sinon.createSandbox();
    mockPoolQuery = sandbox.stub(pool, "query");
  });

  afterEach(() => {
    sandbox.restore();
  });

  describe("getInventario()", () => {
    it("debería devolver todos los vehículos con estado 200", async () => {
      const mockRows = [
        { id: 1, vin: "VIN1", modelo: "Modelo1" },
        { id: 2, vin: "VIN2", modelo: "Modelo2" },
      ];
      mockPoolQuery.resolves({ rows: mockRows });

      const req = {};
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.getInventario(req, res);

      expect(res.status.calledWith(200)).to.be.true;
      expect(res.json.calledWith(mockRows)).to.be.true;
    });

    it("debería devolver error 500 en fallo de BD", async () => {
      mockPoolQuery.rejects(new Error("DB error"));

      const req = {};
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.getInventario(req, res);

      expect(res.status.calledWith(500)).to.be.true;
      expect(res.json.calledWith({ error: "Error al obtener el inventario" }))
        .to.be.true;
    });
  });

  describe("getVehiculo()", () => {
    it("debería devolver un vehículo existente", async () => {
      const mockRow = { id: 1, vin: "VIN123" };
      mockPoolQuery.resolves({ rows: [mockRow] });

      const req = { params: { id: "1" } };
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.getVehiculo(req, res);

      expect(res.json.calledWith(mockRow)).to.be.true;
    });

    it("debería devolver 404 para vehículo inexistente", async () => {
      mockPoolQuery.resolves({ rows: [] });

      const req = { params: { id: "999" } };
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.getVehiculo(req, res);

      expect(res.status.calledWith(404)).to.be.true;
      expect(res.json.calledWith({ error: "Vehículo no encontrado" })).to.be
        .true;
    });
  });

  describe("crearVehiculo()", () => {
    it("debería crear un nuevo vehículo con status 201", async () => {
      const newVehiculo = {
        vin: "NEWVIN",
        modelo: "ModeloNuevo",
        marca: "MarcaNueva",
        año: 2023,
        cantidad: 1,
        ubicacion: "NuevaUbicacion",
        estado: "nuevo",
      };

      const mockResult = { rows: [{ id: 3, ...newVehiculo }] };
      mockPoolQuery.resolves(mockResult);

      const req = { body: newVehiculo };
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.crearVehiculo(req, res);

      expect(res.status.calledWith(201)).to.be.true;
      expect(res.json.calledWith(mockResult.rows[0])).to.be.true;
    });

    it("debería registrar errores de validación", async () => {
      const badVehiculo = { vin: "INVALID" };
      mockPoolQuery.rejects(new Error("Invalid data"));

      const req = { body: badVehiculo };
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.crearVehiculo(req, res);

      expect(res.status.calledWith(500)).to.be.true;
      expect(
        res.json.calledWith({
          error: "Error al crear el vehículo",
          detalle: sinon.match.string,
        })
      ).to.be.true;
    });
  });

  describe("actualizarVehiculo()", () => {
    it("debería actualizar un vehículo existente", async () => {
      const updatedData = {
        vin: "UPDATEDVIN",
        modelo: "ModeloActualizado",
        marca: "MarcaActualizada",
        año: 2024,
        cantidad: 2,
        ubicacion: "UbicacionActualizada",
        estado: "usado",
      };

      const mockResult = { rows: [{ id: 1, ...updatedData }] };
      mockPoolQuery.resolves(mockResult);

      const req = {
        params: { id: "1" },
        body: updatedData,
      };
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.actualizarVehiculo(req, res);

      expect(res.json.calledWith(mockResult.rows[0])).to.be.true;
    });

    it("debería fallar al actualizar vehículo inexistente", async () => {
      mockPoolQuery.resolves({ rows: [] });

      const req = {
        params: { id: "999" },
        body: { modelo: "Actualizado" },
      };
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.actualizarVehiculo(req, res);

      expect(res.status.calledWith(404)).to.be.true;
    });
  });

  describe("eliminarVehiculo()", () => {
    it("debería eliminar un vehículo existente", async () => {
      const mockResult = { rows: [{ id: 1 }] };
      mockPoolQuery.resolves(mockResult);

      const req = { params: { id: "1" } };
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.eliminarVehiculo(req, res);

      expect(
        res.json.calledWith({ mensaje: "Vehículo eliminado correctamente" })
      ).to.be.true;
    });

    it("debería fallar al eliminar vehículo inexistente", async () => {
      mockPoolQuery.resolves({ rows: [] });

      const req = { params: { id: "999" } };
      const res = {
        status: sinon.stub().returnsThis(),
        json: sinon.stub(),
      };

      await inventarioController.eliminarVehiculo(req, res);

      expect(res.status.calledWith(404)).to.be.true;
    });
  });
});
