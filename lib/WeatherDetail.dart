import 'package:flutter/material.dart';

import 'weather.dart';
import 'weather_service.dart';

class WeatherDetail extends StatefulWidget {
  final String city;

  WeatherDetail({required this.city});

  @override
  _WeatherDetailState createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> {
  late Future<Weather> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = WeatherService().fetchWeather(widget.city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.city)),
      body: FutureBuilder<Weather>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final weather = snapshot.data!;
            String weatherImage;

            // กำหนดรูปภาพตามสภาพอากาศ
            if (weather.weatherDescription.contains('clear')) {
              weatherImage = 'assets/images/clear.png';
            } else if (weather.weatherDescription.contains('rain')) {
              weatherImage = 'assets/images/rain.png';
            } else if (weather.weatherDescription.contains('cloud')) {
              weatherImage = 'assets/images/cloudy.png';
            } else if (weather.weatherDescription.contains('snow')) {
              weatherImage = 'assets/images/snow.png';
            } else {
              weatherImage = 'assets/images/default.png'; // รูปภาพเริ่มต้น
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Temperature: ${weather.temp}°C',
                      style: TextStyle(fontSize: 24)),
                  // แสดงรูปภาพ
                  SizedBox(height: 20),
                  Image.asset(weatherImage,
                      height: 200, width: 200), // ปรับขนาดตามที่ต้องการ
                  // แสดงข้อมูลอื่น ๆ
                  Text('Min Temperature: ${weather.tempMin}°C'),
                  Text('Max Temperature: ${weather.tempMax}°C'),
                  Text('Pressure: ${weather.pressure} hPa'),
                  Text('Humidity: ${weather.humidity}%'),
                  Text('Sea Level: ${weather.seaLevel} m'),
                  Text('Clouds: ${weather.clouds}%'),
                  Text('Rain (last hour): ${weather.rain} mm'),
                  Text(
                      'Sunset: ${DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000).toLocal()}'),
                  SizedBox(height: 20),
                  Text('Weather: ${weather.weatherDescription}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
