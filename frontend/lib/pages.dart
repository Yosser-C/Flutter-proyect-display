// pages/inventario_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'delete_inventario.dart';
import 'inventario_controler.dart';

class InventarioPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventarioControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: state.when(
        data:
            (productos) => ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return ListTile(
                  title: Text(producto.vin),
                  subtitle: Text('VIN: ${producto.vin}'),
                  trailing: DeleteInventarioButton(producto: producto),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
