import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String condition;
  final String description;
  final String icon;
  final String location;
  final double minTemp;
  final double maxTemp;
  final double currentTemp;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDirection;
  final int sunrise;
  final int sunset;

  Weather({
    this.condition,
    this.currentTemp,
    this.humidity,
    this.location,
    this.minTemp,
    this.maxTemp,
    this.pressure,
    this.windSpeed,
    this.windDirection,
    this.sunrise,
    this.sunset,
    this.description,
    this.icon,
  });

  static Weather fromJson(dynamic json) {
    return Weather(
        condition: json['weather'][0]['main'],
        currentTemp: json['main']['temp'],
        humidity: json['main']['humidity'],
        location: json['name'],
        minTemp: json['main']['temp_min'],
        maxTemp: json['main']['temp_max'],
        pressure: json['main']['pressure'],
        windSpeed: json['wind']['speed'],
        windDirection: json['wind']['deg'],
        sunrise: json['sys']['sunrise'],
        sunset: json['sys']['sunset'],
        description: json['weather'][0]['description'],
        icon: json['weather'][0]['icon']);
  }

  @override
  List<Object> get props => [
        condition,
        currentTemp,
        humidity,
        location,
        minTemp,
        maxTemp,
        pressure,
        windSpeed,
        windDirection,
        sunrise,
        sunset,
        description,
        icon
      ];
}
