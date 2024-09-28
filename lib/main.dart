import 'package:flutter/material.dart';
import 'weather.dart';
import 'weather_service.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CityList(),
    );
  }
}

class CityList extends StatelessWidget {
  final List<String> cities = ['Bangkok', 'Chiang Mai', 'Phuket'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('City List')),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cities[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherDetail(city: cities[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Temperature: ${weather.temp}°C',
                      style: TextStyle(fontSize: 24)),
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
                  // แสดงรูปตามสภาพอากาศ (คุณสามารถเพิ่มรูปภาพได้ตามที่คุณต้องการ)
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
