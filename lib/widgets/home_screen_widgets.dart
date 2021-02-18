import 'package:flutter/material.dart';
import 'package:weather_forecast/utilities/constants.dart';

// Large Temperature and Icon
Expanded fistRowWidget(
    {String temperature,
    IconData weatherIcon,
    Color iconColor,
    double iconSize}) {
  return Expanded(
    flex: 4,
    child: Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            "$temperature°",
            style: kLargeTempStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.centerRight,
            child: Center(
              child: Icon(
                weatherIcon,
                color: iconColor,
                size: iconSize,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Day description with details
Expanded secondRowWidget(
    {String dayDescription,
    String highestTemp,
    String lowestTemp,
    String currentTemp}) {
  return Expanded(
    flex: 2,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$dayDescription Day",
                style: kBoldTextStyle,
              ),
              Text(
                "$highestTemp°/$lowestTemp°",
              ),
              SizedBox(
                width: 1,
              )
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.centerRight,
            child: Center(
              child: Text(
                "Feels like $currentTemp°",
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Detailed Description BoxDecoration
Center detailBox(
    {BuildContext context, IconData displayIcon, String followingText}) {
  return Center(
    child: Container(
        child: Row(
      children: [
        Icon(
          displayIcon,
          color: Theme.of(context).accentColor,
        ),
        SizedBox(
          width: 15,
        ),
        Text(followingText)
      ],
    )),
  );
}

// Notification Message
SizedBox notificationMessage({Color circleColor, String displayText}) {
  return SizedBox(
    height: kCurrentMessageRowHeight,
    child: Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Icon(
                  Icons.circle,
                  color: circleColor,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Text(displayText),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

// Today with Date
Row todayWithDate({String day, String date}) {
  return Row(
    children: [
      Text(
        day,
        style: kBoldTextStyle,
      ),
      Text(" - $date (Today)")
    ],
  );
}

// Hourly Forecast Box
Column hourlyForecastBox(
    {String temperature, IconData weatherIcon, String time}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text("$temperature°"),
      Icon(weatherIcon),
      SizedBox(height: 5),
      Text(time),
    ],
  );
}

// Padded hourlyForecastBox (for time not "NOW")
Padding paddedHourlyForecastBox(
    {String temperature, IconData weatherIcon, String time}) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Container(
        child: hourlyForecastBox(
            temperature: temperature, weatherIcon: weatherIcon, time: time)),
  );
}

// Next Day Tile
Padding dayTile(
    {String day,
    String highestTemperature,
    String lowestTemperature,
    IconData weatherIcon,
    List<Widget> widgetList}) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 1,
          )
        ],
      ),
      child: Center(
        child: ExpansionTile(
          trailing: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$highestTemperature°/$lowestTemperature°    ",
                  style: TextStyle(color: Colors.black),
                ),
                WidgetSpan(
                  child: Icon(weatherIcon),
                )
              ],
            ),
          ),
          title: Text(day),
          children: widgetList,
        ),
      ),
    ),
  );
}

// BottomNavigation Icons
Icon bottomNavigationIcon({IconData icon}) {
  return Icon(
    icon,
    size: kBottomNaviIconSize,
    color: Colors.white,
  );
}
