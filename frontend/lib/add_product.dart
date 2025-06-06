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

  // AQUÍ ESTABA FALTANDO EL MÉTODO BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.producto == null ? 'Agregar Producto' : 'Editar Producto',
        ),
        backgroundColor: const Color(0xFF1C1E22),
      ),
      backgroundColor: const Color(0xFF1C1E22),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: vinController,
                decoration: const InputDecoration(labelText: 'VIN'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Ingrese VIN' : null,
                enabled: widget.producto == null,
              ),
              TextFormField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese modelo'
                            : null,
              ),
              TextFormField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextFormField(
                controller: anioController,
                decoration: const InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: ubicacionController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarProducto,
                child: Text(widget.producto == null ? 'Agregar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
