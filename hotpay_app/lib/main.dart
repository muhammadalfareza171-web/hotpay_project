import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HotPay App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _apiService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Makanan HotPay'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal terhubung ke Server Laravel:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada menu makanan tersedia.'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.fastfood, size: 40, color: Colors.deepOrange),
                  title: Text(
                    product['product_name'] ?? 'Tanpa Nama',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(product['description'] ?? '-'),
                  trailing: Text(
                    'Rp ${product['price']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}