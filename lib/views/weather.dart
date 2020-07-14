import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weatherBloc.dart';
import 'package:weather_app/bloc/weatherEvent.dart';
import 'package:weather_app/bloc/weatherState.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/models.dart';

final weatherCityController = TextEditingController();

class WeatherView extends StatefulWidget {
  State<WeatherView> createState() => _WeatherState();
}

Completer<void> _refreshCompleter;

class _WeatherState extends State<WeatherView> {
  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    return Scaffold(
      backgroundColor: Color(0xff00001f),
      body: BlocConsumer<WeatherBloc, WeatherStates>(
        listener: (context, WeatherStates state) {
          if (state is WeatherLoaded) {
            print('Im here');
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, WeatherStates state) {
          print(context);
          print(state);
          if (state is WeatherEmpty) {
            return EnterCity();
          } else if (state is WeatherLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherLoaded) {
            final weather = state.weather;
            return RefreshIndicator(
              onRefresh: () {
                BlocProvider.of<WeatherBloc>(context)
                    .add(RefreshWeather(city: weather.location));
                return _refreshCompleter.future;
              },
              child: ListView(
                children: <Widget>[
                  DisplayWeather(
                    weather: weather,
                  ),
                ],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, right: 30),
                  child: Text(
                    'Could not fetch weather for the given location',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                    },
                    child: InkWell(
                      child: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            );
          }
        },
      ),
    );
  }
}

class EnterCity extends StatelessWidget {
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.blueAccent[100],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Text(
                      'Search for Weather',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Container(
                child: TextFormField(
                    controller: weatherCityController,
                    keyboardType: TextInputType.text,
                    keyboardAppearance: Brightness.light,
                    enableSuggestions: true,
                    textInputAction: TextInputAction.search,
                    validator: (value) {
                      if (value.isEmpty) return 'Enter City Name';
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Enter City Name',
                        focusColor: Colors.blueAccent[100],
                        alignLabelWithHint: true,
                        hintText: 'Eg London',
                        prefixIcon: Icon(Icons.location_on),
                        helperText:
                            'Enter the location for which you want to search')),
              ),
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print(weatherCityController.text);
                  BlocProvider.of<WeatherBloc>(context)
                      .add(FetchWeather(city: weatherCityController.text));
                }
              },
              color: Colors.blueAccent[100],
              splashColor: Colors.black,
              padding: EdgeInsets.only(left: 32, right: 32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(color: Colors.blueAccent[100])),
              child: Padding(
                padding: const EdgeInsets.only(left: 32, right: 32),
                child: Text('Search',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            Spacer(),
            SafeArea(
              child: Container(
                child: Text('This app is a demo app for Flutter Bloc Pattern'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DisplayWeather extends StatelessWidget {
  final Weather weather;
  final DateTime now = DateTime.now();

  DisplayWeather({@required this.weather});

  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 80, left: 20),
                    child: Container(
                      child: Text(
                        weather.location,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Container(
                      child: Text(
                        DateFormat('EEEE MMMM d, yyyy hh:mm a').format(now),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 65, right: 20),
                child: Container(
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                    },
                    child: InkWell(
                      child: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Spacer(),
                Container(
                  child: Image.network(
                    'http://openweathermap.org/img/wn/' +
                        weather.icon +
                        '@2x.png',
                    scale: 0.8,
                    color: Colors.white,
                  ),
                ),
                Spacer()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Spacer(),
                Container(
                  child: Text(
                    (weather.currentTemp - 275.5).floor().toString() + '°',
                    style: TextStyle(fontSize: 70, fontWeight: FontWeight.w400),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Spacer(),
                Container(
                  child: Text(
                    weather.condition,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 55, left: 30, right: 30),
            child: Row(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          weather.windSpeed.toString() + 'km/h',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Wind',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          weather.humidity.toString() + '%',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Humidity',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          (weather.maxTemp - 275.5).floor().toString() + '°',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Maximum',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
            child: Row(
              children: <Widget>[
                Spacer(),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          weather.pressure.toString() + ' atm',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Pressure',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          (weather.minTemp - 275.5).floor().toString() + '°',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Minimum',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
