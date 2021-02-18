import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_forecast/utilities/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_forecast/widgets/home_screen_widgets.dart';
import 'package:weather_forecast/services/weather.dart';
import 'package:weather_forecast/screens/search_screen.dart';
import 'package:weather_forecast/screens/loading_screen_city_search.dart';
import 'package:weather_forecast/screens/loading_screen_location_search.dart';

// Use a Stateful widget
class HomeScreen extends StatefulWidget {
  HomeScreen({this.locationWeather});
  final locationWeather;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherModel weather = WeatherModel();
  ForecastDetails forecastDetails;
  // Now passing into ths State
  @override
  void initState() {
    // Pasing location weather into this state
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherDataList){
    setState(() {
      forecastDetails = weather.getDetails(weatherDataList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${forecastDetails.cityName}, ${forecastDetails.countryName}"),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context){
                              return SearchScreen();
                            }
                        )
                    );
                    if (typedName != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context){
                                return LoadingScreenCitySearch(typedName: typedName);
                              }
                          )
                      );

                    }
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.gps_fixed_sharp,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context){
                              return LoadingScreenLocationSearch();
                            }
                        )
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: kCurrentWeatherRowHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            fistRowWidget(
                                temperature: "${forecastDetails.temperature.toString()}",
                                weatherIcon: forecastDetails.currentIcon,
                                iconColor: forecastDetails.currentIconColor,
                                iconSize: 70),
                            secondRowWidget(
                                dayDescription: "${forecastDetails.dayType}",
                                highestTemp: "${forecastDetails.highestTemp.toString()}",
                                lowestTemp: "${forecastDetails.lowestTemp.toString()}",
                                currentTemp: "${forecastDetails.feelsTemp.toString()}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: kCurrentDetailedRowHeight,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                detailBox(
                                    context: context,
                                    displayIcon: WeatherIcons.sunrise,
                                    followingText: "${forecastDetails.sunriseTime} am"),
                                detailBox(
                                    context: context,
                                    displayIcon: WeatherIcons.sunset,
                                    followingText: "${forecastDetails.sunsetTime} pm"),
                                detailBox(
                                    context: context,
                                    displayIcon: WeatherIcons.strong_wind,
                                    followingText: "${forecastDetails.windSpeed} km/h"),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                detailBox(
                                    context: context,
                                    displayIcon: WeatherIcons.cloudy,
                                    followingText: "${forecastDetails.rainChance} %"),
                                detailBox(
                                    context: context,
                                    displayIcon: WeatherIcons.day_sunny,
                                    followingText: "UV: ${forecastDetails.uvRate}"),
                                detailBox(
                                    context: context,
                                    displayIcon: WeatherIcons.raindrops,
                                    followingText: "${forecastDetails.humidityRate} %"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                notificationMessage(
                    circleColor: Colors.green,
                    displayText:
                        "${forecastDetails.singleLineComment} "),
                SizedBox(
                  height: kHourlyRowHeight,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: todayWithDate(
                                    day: forecastDetails.today, date: forecastDetails.date)),
                            Expanded(
                              flex: 3,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // First Box is specially bounded - We can further replaced based on index Tap
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              spreadRadius: 2,
                                              blurRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: hourlyForecastBox(
                                            temperature: forecastDetails.temperature.toString(),
                                            weatherIcon: forecastDetails.currentIcon,
                                            time: "Now"),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: paddedHourlyForecastBox(
                                          temperature: forecastDetails.hourPlusOneTemp.toString(),
                                          weatherIcon: forecastDetails.hourPlusOneIcon,
                                          time: forecastDetails.hourPlusOne)),
                                  Expanded(
                                      child: paddedHourlyForecastBox(
                                          temperature: forecastDetails.hourPlusTwoTemp.toString(),
                                          weatherIcon:
                                              forecastDetails.hourPlusTwoIcon,
                                          time: forecastDetails.hourPlusTwo)),
                                  Expanded(
                                      child: paddedHourlyForecastBox(
                                          temperature: forecastDetails.hourPlusThreeTemp.toString(),
                                          weatherIcon: forecastDetails.hourPlusThreeIcon,
                                          time: forecastDetails.hourPlusThree)),
                                  Expanded(
                                      child: paddedHourlyForecastBox(
                                          temperature: forecastDetails.hourPlusFourTemp.toString(),
                                          weatherIcon: forecastDetails.hourPlusFourIcon,
                                          time: forecastDetails.hourPlusFour)),
                                  Expanded(
                                      child: paddedHourlyForecastBox(
                                          temperature: forecastDetails.hourPlusFiveTemp.toString(),
                                          weatherIcon: forecastDetails.hourPlusFiveIcon,
                                          time: forecastDetails.hourPlusFive)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    dayTile(
                        day: "Tomorrow",
                        highestTemperature: forecastDetails.dayPlusOneHighestTemp.toString(),
                        lowestTemperature: forecastDetails.dayPlusOneLowestTemp.toString(),
                        weatherIcon: forecastDetails.dayPlusOneIcon,
                        widgetList: [Text("More Stuff Here Please")]),
                    dayTile(
                        day: forecastDetails.dayPlusTwo,
                        highestTemperature: forecastDetails.dayPlusTwoHighestTemp.toString(),
                        lowestTemperature: forecastDetails.dayPlusTwoLowestTemp.toString(),
                        weatherIcon: forecastDetails.dayPlusTwoIcon,
                        widgetList: [Text("More Stuff Here Please")]),
                    dayTile(
                        day: forecastDetails.dayPlusThree,
                        highestTemperature: forecastDetails.dayPlusThreeHighestTemp.toString(),
                        lowestTemperature: forecastDetails.dayPlusThreeLowestTemp.toString(),
                        weatherIcon: forecastDetails.dayPlusThreeIcon,
                        widgetList: [Text("More Stuff Here Please")]),
                    dayTile(
                        day: forecastDetails.dayPlusFour,
                        highestTemperature: forecastDetails.dayPlusFourHighestTemp.toString(),
                        lowestTemperature: forecastDetails.dayPlusFourLowestTemp.toString(),
                        weatherIcon: forecastDetails.dayPlusFourIcon,
                        widgetList: [Text("More Stuff Here Please")]),
                    dayTile(
                        day: forecastDetails.dayPlusFive,
                        highestTemperature: forecastDetails.dayPlusFiveHighestTemp.toString(),
                        lowestTemperature: forecastDetails.dayPlusFiveLowestTemp.toString(),
                        weatherIcon: forecastDetails.dayPlusFiveIcon,
                        widgetList: [Text("More Stuff Here Please")]),
                    dayTile(
                        day: forecastDetails.dayPlusSix,
                        highestTemperature: forecastDetails.dayPlusSixHighestTemp.toString(),
                        lowestTemperature: forecastDetails.dayPlusSixLowestTemp.toString(),
                        weatherIcon: forecastDetails.dayPlusSixIcon,
                        widgetList: [Text("More Stuff Here Please")]),
                    dayTile(
                        day: forecastDetails.dayPlusSeven,
                        highestTemperature: forecastDetails.dayPlusSevenHighestTemp.toString(),
                        lowestTemperature: forecastDetails.dayPlusSevenLowestTemp.toString(),
                        weatherIcon: forecastDetails.dayPlusSevenIcon,
                        widgetList: [Text("More Stuff Here Please")]),
                    SizedBox(
                      height: 10,
                    ) // Padding box so the bottom tile is not overlapped with dayBox
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: Theme.of(context).accentColor,
          height: kBottomNaviBarHeight,
          color: Colors.grey,
          backgroundColor: Theme.of(context).primaryColor,
          items: <Widget>[
            bottomNavigationIcon(icon: Icons.home),
            bottomNavigationIcon(icon: Icons.calendar_today),
            bottomNavigationIcon(icon: Icons.add),
            bottomNavigationIcon(icon: Icons.assistant_navigation),
            bottomNavigationIcon(icon: Icons.play_arrow),
          ],
          onTap: (index) {},
        ),
      ),
    );
  }
}
