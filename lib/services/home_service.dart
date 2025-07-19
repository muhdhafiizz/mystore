import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mystore_assessment/model/product_model.dart';

class HomeService {
  Future<List<Product>> fetchProducts({int skip = 0, int limit = 15}) async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> productsJson = jsonBody['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<String>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products/categories'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> categoriesJson = jsonDecode(response.body);

      return categoriesJson
          .map((category) => category['name'] as String)
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Product>> fetchProductsByCategory(
    String category, {
    int skip = 0,
    int limit = 15,
  }) async {
    final response = await http.get(
      Uri.parse(
        'https://dummyjson.com/products/category/$category?limit=$limit&skip=$skip',
      ),
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> productsJson = jsonBody['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load category products');
    }
  }
}
