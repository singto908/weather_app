class Weather {
  final String cityName;
  final double temp;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double seaLevel;
  final int clouds;
  final double rain;
  final int sunset;
  final String weatherDescription;
  final String iconUrl;

  Weather({
    required this.cityName,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.clouds,
    required this.rain,
    required this.sunset,
    required this.weatherDescription,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temp: json['main']['temp'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      seaLevel: json['main']['sea_level']?.toDouble() ?? 0.0,
      clouds: json['clouds']['all'],
      rain: json['rain'] != null ? json['rain']['1h'] : 0.0,
      sunset: json['sys']['sunset'],
      weatherDescription: json['weather'][0]['description'],
      iconUrl: json['weather'][0]['icon'],
    );
  }
}
