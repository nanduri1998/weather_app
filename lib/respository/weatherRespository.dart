import 'package:weather_app/respository/WeatherAPIClient.dart';
import 'package:weather_app/models/models.dart';
import 'dart:async';
import 'package:meta/meta.dart';

class WeatherRepository {
  final WeatherAPIClient weatherAPIClient;

  WeatherRepository({@required this.weatherAPIClient})
      : assert(weatherAPIClient != null);
  Future<Weather> getWeather(String city) {
    return weatherAPIClient.getWeather(city);
  }
}
