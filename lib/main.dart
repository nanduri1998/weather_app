import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weatherBloc.dart';
import 'package:weather_app/observers/simpleBlocObserver.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/respository/respository.dart';
import 'package:weather_app/views/weather.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  final WeatherRepository weatherRepository = WeatherRepository(
      weatherAPIClient: WeatherAPIClient(httpClient: http.Client()));
  runApp(App(weatherRepository: weatherRepository));
}

class App extends StatelessWidget {
  final WeatherRepository weatherRepository;
  App({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: BlocProvider(
          create: (context) =>
              WeatherBloc(weatherRepository: weatherRepository),
          child: WeatherView(),
        ));
  }
}
