// models/inventario.dart
class Inventario {
  final String vin;
  final String descripcion;
  final double precio;
  final int cantidad;

  Inventario({
    required this.vin,
    required this.descripcion,
    required this.precio,
    required this.cantidad,
  });

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      vin: json['vin'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num).toDouble(),
      cantidad: json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vin': vin,
      'descripcion': descripcion,
      'precio': precio,
      'cantidad': cantidad,
    };
  }
}
