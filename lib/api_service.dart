import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class ApiService {
  static final Uri baseUrl = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=3df2416abe25496a80263ff0c5d7d6c3');
  static const String apiKey = Config.apiKey;

  static Future<List<Map<String, dynamic>>> fetchNews() async {
    final response = await http.get(
      baseUrl,
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['articles']);
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
