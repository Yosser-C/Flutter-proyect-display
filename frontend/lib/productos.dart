class Inventario {
  final String vin;
  final String modelo;
  final String marca;
  final int anio;
  final int cantidad;
  final String ubicacion;
  final String estado;

  Inventario({
    required this.vin,
    required this.modelo,
    required this.marca,
    required this.anio,
    required this.cantidad,
    required this.ubicacion,
    required this.estado,
  });

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      vin: json['vin']?.toString() ?? '',
      modelo: json['modelo']?.toString() ?? '',
      marca: json['marca']?.toString() ?? '',
      anio: _parseInt(json['anio'] ?? json['año'] ?? 0),
      cantidad: _parseInt(json['cantidad'] ?? 0),
      ubicacion: json['ubicacion']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vin': vin,
      'modelo': modelo,
      'marca': marca,
      'año': anio,
      'cantidad': cantidad,
      'ubicacion': ubicacion,
      'estado': estado,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    } else {
      return 0;
    }
  }
}
