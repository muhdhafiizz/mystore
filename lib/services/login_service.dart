import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('https://dummyjson.com/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Login failed');
    }
  }
}
