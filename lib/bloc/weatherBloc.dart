import 'package:bloc/bloc.dart';
import 'package:weather_app/bloc/bloc.dart';
import 'package:weather_app/respository/respository.dart';
import 'package:weather_app/models/models.dart';
import 'package:meta/meta.dart';

class WeatherBloc extends Bloc<WeatherEvents, WeatherStates> {
  final WeatherRepository weatherRepository;
  WeatherBloc({@required this.weatherRepository})
      : assert(weatherRepository != null),
        super(WeatherEmpty());

  @override
  Stream<WeatherStates> mapEventToState(
    WeatherEvents event,
  ) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final Weather weather = await weatherRepository.getWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch (error) {
        print(error);
        yield WeatherError();
      }
    } else if (event is RefreshWeather) {
      try {
        final Weather weather = await weatherRepository.getWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch (error) {
        print("Error" + error);
        yield state;
      }
    } else if (event is ResetWeather) {
      yield WeatherEmpty();
    }
  }
}
