import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'productos.dart';
import 'inventario_controler.dart';

class DeleteInventarioButton extends ConsumerWidget {
  final Inventario producto;

  const DeleteInventarioButton({super.key, required this.producto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Eliminar Producto'),
              content: const Text('¿Seguro que deseas eliminar este producto?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        );

        if (confirmDelete ?? false) {
          try {
            await ref
                .read(inventarioControllerProvider.notifier)
                .deleteProducto(
                  producto.vin,
                ); // Asegúrate de que "vin" sea correcto
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Producto eliminado')));
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
          }
        }
      },
    );
  }
}
