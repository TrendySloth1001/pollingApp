import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';
import '../models/hello_response.dart';

class HelloService {
  Future<HelloResponse> fetchHello() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/hello'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return HelloResponse.fromJson(data);
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
