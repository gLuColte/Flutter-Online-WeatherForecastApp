import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_forecast/services/weather.dart';
import 'package:weather_forecast/screens/home_screen.dart';

class LoadingScreenLocationSearch extends StatefulWidget {
  @override
  _LoadingScreenLocationSearchState createState() => _LoadingScreenLocationSearchState();
}

class _LoadingScreenLocationSearchState extends State<LoadingScreenLocationSearch> {

  void getLocationData() async{
    var weatherData = await WeatherModel().getCurrentCityWeather();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context){
              return HomeScreen(locationWeather:weatherData,);
            }
        )
    );
  }

  @override
  void initState(){
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SpinKitCubeGrid(
            color: Theme.of(context).accentColor,
            size: 100,
          ),
        ),
      ),
    );
  }
}

