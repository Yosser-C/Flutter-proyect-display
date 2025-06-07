import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'productos.dart';

final inventarioControllerProvider =
    StateNotifierProvider<InventarioController, AsyncValue<List<Inventario>>>(
      (ref) => InventarioController(ref),
    );

class InventarioController extends StateNotifier<AsyncValue<List<Inventario>>> {
  final Ref ref;

  InventarioController(this.ref) : super(const AsyncValue.loading()) {
    loadInventario();
  }

  Future<void> loadInventario() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.112.1:3001/api/products'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final productos = data.map((e) => Inventario.fromJson(e)).toList();
        state = AsyncValue.data(productos);
      } else {
        state = AsyncValue.error('Error al cargar', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> deleteProducto(String vin) async {
    final url =
        'https://automativecompany-backend.onrender.com/api/products/$vin';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 204 || response.statusCode == 200) {
      await loadInventario();
    } else {
      throw Exception('Error al eliminar producto');
    }
  }

  Future<void> addProducto(Inventario nuevo) async {
    final response = await http.post(
      Uri.parse('https://automativecompany-backend.onrender.com/api/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevo.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      await loadInventario();
    } else {
      throw Exception('Error al agregar producto');
    }
  }

  Future<void> editProducto(String vin, Inventario actualizado) async {
    final response = await http.patch(
      Uri.parse(
        'https://automativecompany-backend.onrender.com/api/products/$vin',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(actualizado.toJson()),
    );
    if (response.statusCode == 200) {
      await loadInventario();
    } else {
      throw Exception('Error al editar producto');
    }
  }
}
