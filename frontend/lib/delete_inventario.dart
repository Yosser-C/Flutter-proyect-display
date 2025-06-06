// widgets/delete_inventario_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inventario_controler.dart';
import 'productos.dart';

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
          builder:
              (_) => AlertDialog(
                title: const Text('Eliminar Producto'),
                content: const Text(
                  '¿Seguro que deseas eliminar este producto?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
        );

        if (confirmDelete ?? false) {
          try {
            await ref
                .read(inventarioControllerProvider.notifier)
                .deleteProducto(producto.vin);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Producto eliminado')));
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $e')));
          }
        }
      },
    );
  }
}
