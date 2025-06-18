import 'package:http/http.dart' as http;
import 'dart:convert';

import 'weather.dart';

class WeatherService {
  final String apiKey =
      'a214c2d281e4c37d4a0120727d4d6656'; // ใส่ API Key ของคุณที่นี่
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to load weather data');
    }
  }
}
