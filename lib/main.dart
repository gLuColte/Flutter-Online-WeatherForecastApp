import 'package:flutter/material.dart';
import 'screens/loading_screen_location_search.dart';

void main() {
  runApp(WeatherForecast());
}

class WeatherForecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.lightBlue,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Lato-Regular',
      ),
      debugShowCheckedModeBanner: false,
      home: LoadingScreenLocationSearch(),
    );
  }
}
