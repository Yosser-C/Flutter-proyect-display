import 'package:flutter/material.dart';
import 'api_services.dart';
import 'productos.dart';

class AddProductPage extends StatefulWidget {
  final Inventario? producto;
  const AddProductPage({super.key, this.producto});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  late TextEditingController modeloController;
  late TextEditingController marcaController;
  late TextEditingController anioController;
  late TextEditingController vinController;
  late TextEditingController cantidadController;
  late TextEditingController ubicacionController;
  late TextEditingController estadoController;

  @override
  void initState() {
    super.initState();
    modeloController = TextEditingController(
      text: widget.producto?.modelo ?? '',
    );
    marcaController = TextEditingController(text: widget.producto?.marca ?? '');
    anioController = TextEditingController(
      text: widget.producto?.anio.toString() ?? '',
    );
    vinController = TextEditingController(text: widget.producto?.vin ?? '');
    cantidadController = TextEditingController(
      text: widget.producto?.cantidad.toString() ?? '',
    );
    ubicacionController = TextEditingController(
      text: widget.producto?.ubicacion ?? '',
    );
    estadoController = TextEditingController(
      text: widget.producto?.estado ?? '',
    );
  }

  @override
  void dispose() {
    modeloController.dispose();
    marcaController.dispose();
    anioController.dispose();
    vinController.dispose();
    cantidadController.dispose();
    ubicacionController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  void _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      print('Datos del formulario validados');
      final producto = Inventario(
        vin: vinController.text,
        modelo: modeloController.text,
        marca: marcaController.text,
        anio: int.tryParse(anioController.text) ?? 0,
        cantidad: int.tryParse(cantidadController.text) ?? 0,
        ubicacion: ubicacionController.text,
        estado: estadoController.text,
      );

      print('Producto a guardar: ${producto.toJson()}');

      try {
        if (widget.producto == null) {
          print('Intentando agregar producto...');
          await apiService.addProduct(producto);
          print('Producto agregado con éxito');
        } else {
          print('Intentando actualizar producto...');
          await apiService.updateProduct(producto.vin, producto);
          print('Producto actualizado con éxito');
        }
        Navigator.pop(context, true);
      } catch (e, stackTrace) {
        print('Error completo: $e');
        print('Stack trace: $stackTrace');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar producto: ${e.toString()}')),
        );
      }
    }
  }

  // Método para construir campos de texto consistentes
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.white70),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          filled: true,
          fillColor: Colors.grey[900]?.withOpacity(0.7),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.producto == null ? 'Agregar Producto' : 'Editar Producto',
          style: const TextStyle(fontSize: 22),
        ),
        backgroundColor: const Color(0xFF1C1E22),
      ),
      backgroundColor: const Color(0xFF1C1E22),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo VIN
              _buildTextField(
                controller: vinController,
                label: 'VIN',
                enabled: widget.producto == null,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Ingrese VIN' : null,
              ),

              // Campo Modelo
              _buildTextField(
                controller: modeloController,
                label: 'Modelo',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese modelo'
                            : null,
              ),

              // Campo Marca
              _buildTextField(controller: marcaController, label: 'Marca'),

              // Fila para Año y Cantidad
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: anioController,
                      label: 'Año',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTextField(
                      controller: cantidadController,
                      label: 'Cantidad',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              // Fila para Ubicación y Estado
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: ubicacionController,
                      label: 'Ubicación',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTextField(
                      controller: estadoController,
                      label: 'Estado',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _guardarProducto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(
                  widget.producto == null
                      ? 'AGREGAR PRODUCTO'
                      : 'GUARDAR CAMBIOS',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
