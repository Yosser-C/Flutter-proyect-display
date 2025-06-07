import 'dart:convert';
import 'package:http/http.dart' as http;
import 'productos.dart';

class ApiService {
  final String baseUrl =
      'https://automativecompany-backend.onrender.com/api/products';

  Future<List<Inventario>> fetchProductos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Inventario.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  Future<void> addProduct(Inventario nuevoProducto) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(nuevoProducto.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al agregar el producto');
      }
    } catch (error) {
      throw Exception('Error en addProduct: $error');
    }
  }

  Future<void> borrarProducto(String id) async {
    final url = '$baseUrl/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al borrar producto');
    }
  }

  Future<List<Inventario>> fetchPiezas() async {
    final response = await http.get(
      Uri.parse('https://automativecompany-backend.onrender.com/api/piezas'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Inventario.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar piezas');
    }
  }

  Future<void> addPieza(Inventario pieza) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(pieza.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al agregar la pieza');
      }
    } catch (error) {
      throw Exception('Error en addPieza: $error');
    }
  }

  Future<void> updateProduct(String vin, Inventario productoActualizado) async {
    final url = '$baseUrl/$vin';

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(productoActualizado.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto');
    }
  }
}
