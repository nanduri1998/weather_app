import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:weather_app/models/Weather.dart';

abstract class WeatherStates extends Equatable {
  const WeatherStates();

  @override
  List<Object> get props => [];
}

class WeatherEmpty extends WeatherStates {}

class WeatherLoading extends WeatherStates {}

class WeatherLoaded extends WeatherStates {
  final Weather weather;

  WeatherLoaded({@required this.weather}) : assert(weather != null);

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherStates {}
