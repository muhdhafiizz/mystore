import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mystore_assessment/model/category_model.dart';
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
}
