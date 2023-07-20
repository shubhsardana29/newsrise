import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class ApiService {
  static const String _baseUrl = 'https://newsapi.org/v2/top-headlines';
  static const String _countryCode = 'us';
  static const String _category = 'business';

  static Future<List<Map<String, dynamic>>> fetchNews() async {
    String apiKey = Config.getCurrentApiKey(); // Get the current API key

    final response = await http.get(
      Uri.parse('$_baseUrl?country=$_countryCode&category=$_category&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['articles']);
    } else if (response.statusCode == 429) {
      // Quota exhausted, switch to the next API key and retry
      apiKey = Config.switchToNextApiKey();
      return await fetchNews(); // Retry with the next API key
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
