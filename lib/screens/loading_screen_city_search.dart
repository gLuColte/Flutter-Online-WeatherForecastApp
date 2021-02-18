import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_forecast/services/weather.dart';
import 'package:weather_forecast/screens/home_screen.dart';

class LoadingScreenCitySearch extends StatefulWidget {
  LoadingScreenCitySearch({this.typedName});
  final typedName;
  @override
  _LoadingScreenCitySearchState createState() => _LoadingScreenCitySearchState();
}

class _LoadingScreenCitySearchState extends State<LoadingScreenCitySearch> {
  WeatherModel weather = WeatherModel();

  void getCityData() async{
    var coordinate = await weather.getCityDetails(widget.typedName);
    var weatherDataList = await weather.getCityWeatherList(coordinate);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context){
              return HomeScreen(locationWeather:weatherDataList,);
            }
        )
    );
  }

  @override
  void initState(){
    super.initState();
    getCityData();
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

