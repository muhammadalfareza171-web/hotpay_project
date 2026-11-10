import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Mengarahkan base URL ke alamat IP Server Ubuntu (Nginx berjalan di port 80 standar)
  static const String baseUrl = 'http://192.168.56.101/api';

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data']; 
      } else {
        throw Exception('Gagal memuat produk: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error koneksi ke server: $e');
    }
  }
}