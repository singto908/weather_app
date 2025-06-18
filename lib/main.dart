import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Color(0xFFF5F6FA),
      ),
      home: CityList(),
    );
  }
}

class CityList extends StatelessWidget {
  final List<String> cities = ['Bangkok', 'Chiang Mai', 'Phuket'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather by City'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: cities.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.location_city, color: Colors.indigo),
              title: Text(
                cities[index],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherDetail(city: cities[index]),
                  ),
                );
              },
            ),
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

  Widget buildWeatherRow(
      {required IconData icon, required String label, required String value}) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(label),
      trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.city), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade300, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Weather>(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final weather = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Center(
                        child: Text(
                          '${weather.temp}°C',
                          style: TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          weather.weatherDescription,
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[700]),
                        ),
                      ),
                      Divider(height: 32),
                      buildWeatherRow(
                        icon: Icons.thermostat,
                        label: 'Min Temperature',
                        value: '${weather.tempMin}°C',
                      ),
                      buildWeatherRow(
                        icon: Icons.thermostat_outlined,
                        label: 'Max Temperature',
                        value: '${weather.tempMax}°C',
                      ),
                      buildWeatherRow(
                        icon: Icons.compress,
                        label: 'Pressure',
                        value: '${weather.pressure} hPa',
                      ),
                      buildWeatherRow(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '${weather.humidity}%',
                      ),
                      buildWeatherRow(
                        icon: Icons.waves,
                        label: 'Sea Level',
                        value: '${weather.seaLevel} m',
                      ),
                      buildWeatherRow(
                        icon: Icons.cloud,
                        label: 'Clouds',
                        value: '${weather.clouds}%',
                      ),
                      buildWeatherRow(
                        icon: Icons.grain,
                        label: 'Rain (1h)',
                        value: '${weather.rain} mm',
                      ),
                      buildWeatherRow(
                        icon: Icons.wb_sunny,
                        label: 'Sunset',
                        value: DateTime.fromMillisecondsSinceEpoch(
                                weather.sunset * 1000)
                            .toLocal()
                            .toString(),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
