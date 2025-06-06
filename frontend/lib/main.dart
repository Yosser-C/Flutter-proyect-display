import 'package:flutter/material.dart';
import 'add_product.dart';
import 'api_services.dart';
import 'productos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AXEMOBILE',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1E22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1E22),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/Auto_rep.png', height: 40),
            const SizedBox(width: 20),
            const Text(
              'AXEMOBILE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BuscarPage()),
                );
              },
              child: const Text(
                'Buscar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Pedidos',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmptyPage()),
                );
              },
              child: const Text(
                'Inventario',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Bienvenido a AXEMOBILE',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

// Servicio global
final ApiService apiService = ApiService();

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: const Color(0xFF1C1E22),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF1C1E22),
      body: FutureBuilder<List<Inventario>>(
        future: apiService.fetchProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay datos en inventario',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final inventarios = snapshot.data!;
            return ListView.builder(
              itemCount: inventarios.length,
              itemBuilder: (context, index) {
                final item = inventarios[index];
                return Card(
                  color: const Color(0xFF2A2D34),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      '${item.modelo} (${item.anio})',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'VIN: ${item.vin} - Cantidad: ${item.cantidad}\nUbicación: ${item.ubicacion} - Estado: ${item.estado}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
      ),
    );
  }
}

// Pantalla BuscarPage
class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  List<Inventario> todasLasPiezas = [];
  List<Inventario> piezasFiltradas = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarPiezas();
    searchController.addListener(filtrarPiezas);
  }

  Future<void> cargarPiezas() async {
    try {
      final piezas =
          await apiService
              .fetchPiezas(); // debes tener esto en tu api-services.dart
      setState(() {
        todasLasPiezas = piezas;
        piezasFiltradas = piezas;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar piezas: $e');
      setState(() => isLoading = false);
    }
  }

  void filtrarPiezas() {
    final query = searchController.text.toLowerCase();
    setState(() {
      piezasFiltradas =
          todasLasPiezas.where((pieza) {
            return pieza.modelo.toLowerCase().contains(query) ||
                pieza.vin.toLowerCase().contains(query);
          }).toList();
    });
  }

  Future<void> comprarPieza(Inventario pieza) async {
    try {
      await apiService.addProduct(
        Inventario(
          modelo: pieza.modelo,
          anio: pieza.anio,
          vin: pieza.vin,
          cantidad: pieza.cantidad,
          ubicacion: pieza.ubicacion,
          estado: pieza.estado,
          marca: '',
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pieza comprada y agregada al inventario'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al comprar: $e')));
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1E22),
      appBar: AppBar(
        title: const Text('Buscar Piezas'),
        backgroundColor: const Color(0xFF1C1E22),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Buscar por modelo o VIN',
                        hintStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: piezasFiltradas.length,
                      itemBuilder: (context, index) {
                        final item = piezasFiltradas[index];
                        return Card(
                          color: const Color(0xFF2A2D34),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Text(
                              '${item.modelo} (${item.anio})',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'VIN: ${item.vin}\nUbicación: ${item.ubicacion} - Estado: ${item.estado}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => comprarPieza(item),
                              child: const Text('Comprar'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
