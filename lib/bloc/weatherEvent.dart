import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WeatherEvents extends Equatable {
  const WeatherEvents();
}

class FetchWeather extends WeatherEvents {
  final String city;
  FetchWeather({@required this.city}) : assert(city != null);

  @override
  List<Object> get props => [city];
}

class RefreshWeather extends WeatherEvents {
  final String city;
  const RefreshWeather({@required this.city}) : assert(city != null);

  @override
  List<Object> get props => [city];
}

class ResetWeather extends WeatherEvents {
  @override
  List<Object> get props => null;
}
