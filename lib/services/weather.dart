import 'package:flutter/material.dart';
import 'package:weather_forecast/services/networking.dart';
import 'package:weather_forecast/services/location.dart';
import 'package:weather_icons/weather_icons.dart';
const apiKey = '61f776c3afbfbb0bbaa719a94124b7aa';
const openWeatherMapOneCallURL = 'https://api.openweathermap.org/data/2.5/onecall';
const openWeatherMapWeatherURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {

  Future<dynamic> getCurrentCityWeather() async{
    Location location = Location();
    await location.getCurrentLocation(); // since we are await = use Future
    NetworkHelper networkHelper1 = NetworkHelper(
        '$openWeatherMapOneCallURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var oneCallData = await networkHelper1.getData();

    await location.getCurrentLocation(); // since we are await = use Future
    NetworkHelper networkHelper2 = NetworkHelper(
        '$openWeatherMapWeatherURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var weatherData = await networkHelper2.getData();

    return [weatherData, oneCallData];
  }

  Future<dynamic> getCityDetails(cityName) async{
    NetworkHelper networkHelper3 = NetworkHelper(
      '$openWeatherMapWeatherURL?q=$cityName&appid=$apiKey&units=metric');
    var cityDetails = await networkHelper3.getData();
    return [cityDetails['coord']['lat'], cityDetails['coord']['lon']];

  }

  Future<dynamic> getCityWeatherList(dynamic coordinateList) async{
    double latitude;
    double longitude;
    latitude = coordinateList[0];
    longitude = coordinateList[1];

    NetworkHelper networkHelper1 = NetworkHelper(
        '$openWeatherMapOneCallURL?lat=${latitude.toString()}&lon=${longitude.toString()}&appid=$apiKey&units=metric');
    var oneCallData = await networkHelper1.getData();

    NetworkHelper networkHelper2 = NetworkHelper(
        '$openWeatherMapWeatherURL?lat=${latitude.toString()}&lon=${longitude.toString()}&appid=$apiKey&units=metric');
    var weatherData = await networkHelper2.getData();

    return [weatherData, oneCallData];

  }

  ForecastDetails getDetails(dynamic weatherDataList) {
    ForecastDetails forecastDetails = ForecastDetails();
    if (weatherDataList[0] == null) {
      return forecastDetails;
    }
    // For icons and Color
    IconData getWeatherIcon(int condition) {
      if (condition < 300) {
        return WeatherIcons.lightning;
      } else if (condition < 400) {
        return WeatherIcons.showers;
      } else if (condition < 600) {
        return WeatherIcons.rain;
      } else if (condition < 700) {
        return WeatherIcons.snow;
      } else if (condition < 800) {
        return WeatherIcons.smog;
      } else if (condition == 800) {
        return WeatherIcons.day_sunny;
      } else if (condition <= 804) {
        return WeatherIcons.cloud;
      } else {
        return WeatherIcons.meteor;
      }
    }
    Color getWeatherIconColor(int condition) {
      if (condition < 300) {
        return Colors.grey;
      } else if (condition < 400) {
        return Colors.blue;
      } else if (condition < 600) {
        return Colors.blueAccent;
      } else if (condition < 700) {
        return Colors.blue;
      } else if (condition < 800) {
        return Colors.blueGrey;
      } else if (condition == 800) {
        return Colors.orange;
      } else if (condition <= 804) {
        return Colors.grey;
      } else {
        return Colors.purple;
      }
    }

    // City and Country Names
    forecastDetails.cityName = weatherDataList[0]["name"];
    forecastDetails.countryName = weatherDataList[0]["sys"]["country"];

    // Today Temperatures
    forecastDetails.temperature = weatherDataList[0]["main"]["temp"].toInt();
    forecastDetails.highestTemp = weatherDataList[0]["main"]["temp_max"].toInt();
    forecastDetails.lowestTemp = weatherDataList[0]["main"]["temp_min"].toInt();
    forecastDetails.feelsTemp = weatherDataList[0]["main"]["feels_like"].toInt();
    forecastDetails.dayType = weatherDataList[0]["weather"][0]["main"];
    forecastDetails.currentIcon = getWeatherIcon(weatherDataList[0]["weather"][0]["id"]);
    forecastDetails.currentIconColor = getWeatherIconColor(weatherDataList[0]["weather"][0]["id"]);

    // Using sunrise time to get today's date
    var sunriseDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[0]["sys"]["sunrise"] * 1000);
    var sunsetDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[0]["sys"]["sunset"] * 1000);
    forecastDetails.sunriseTime = "${sunriseDate.hour}:${sunriseDate.minute}";
    forecastDetails.sunsetTime = "${sunsetDate.hour}:${sunsetDate.minute}";

    // Map for converting to String
    var monthToString = {1: "Jan", 2: "Feb", 3: "Mar", 4: "Apr", 5: "May", 6: "Jun", 7: "Jul", 8: "Aug", 9: "Sep", 10: "Oct", 11: "Nov", 12: "Dec"};
    var dayToString = {1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday", 7: "Sunday"};
    forecastDetails.today = "${dayToString[sunriseDate.weekday]}";
    forecastDetails.date = "${sunriseDate.day} ${monthToString[sunriseDate.month]}";

    forecastDetails.windSpeed = weatherDataList[0]["wind"]["speed"].toString();
    forecastDetails.humidityRate = weatherDataList[0]["main"]["humidity"].toInt();
    forecastDetails.uvRate = weatherDataList[1]["current"]["uvi"].toInt();
    forecastDetails.rainChance = weatherDataList[1]["current"]["clouds"].toInt();
    forecastDetails.singleLineComment = weatherDataList[1]["current"]["weather"][0]["description"];

    // Hourly Forecast
    // 1 hour
    var plusOneHourDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["hourly"][0]["dt"] * 1000);
    forecastDetails.hourPlusOne = "${plusOneHourDate.hour}:00";
    forecastDetails.hourPlusOneTemp = weatherDataList[1]["hourly"][0]["feels_like"].toInt();
    forecastDetails.hourPlusOneIcon = getWeatherIcon(weatherDataList[1]["hourly"][0]["weather"][0]["id"]);

    // 2 hour
    var plusTwoHourDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["hourly"][1]["dt"] * 1000);
    forecastDetails.hourPlusTwo = "${plusTwoHourDate.hour}:00";
    forecastDetails.hourPlusTwoTemp = weatherDataList[1]["hourly"][1]["feels_like"].toInt();
    forecastDetails.hourPlusTwoIcon = getWeatherIcon(weatherDataList[1]["hourly"][1]["weather"][0]["id"]);

    // 3 hour
    var plusThreeHourDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["hourly"][2]["dt"] * 1000);
    forecastDetails.hourPlusThree = "${plusThreeHourDate.hour}:00";
    forecastDetails.hourPlusThreeTemp = weatherDataList[1]["hourly"][2]["feels_like"].toInt();
    forecastDetails.hourPlusThreeIcon = getWeatherIcon(weatherDataList[1]["hourly"][2]["weather"][0]["id"]);

    // 4 hour
    var plusFourHourDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["hourly"][3]["dt"] * 1000);
    forecastDetails.hourPlusFour = "${plusFourHourDate.hour}:00";
    forecastDetails.hourPlusFourTemp = weatherDataList[1]["hourly"][3]["feels_like"].toInt();
    forecastDetails.hourPlusFourIcon = getWeatherIcon(weatherDataList[1]["hourly"][3]["weather"][0]["id"]);

    // 5 hour
    var plusFiveHourDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["hourly"][4]["dt"] * 1000);
    forecastDetails.hourPlusFive = "${plusFiveHourDate.hour}:00";
    forecastDetails.hourPlusFiveTemp = weatherDataList[1]["hourly"][4]["feels_like"].toInt();
    forecastDetails.hourPlusFiveIcon = getWeatherIcon(weatherDataList[1]["hourly"][4]["weather"][0]["id"]);

    // Daily Forecast
    // plus 1 day
    //var plusOneDayDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["daily"][0]["dt"] * 1000);

    forecastDetails.dayPlusOneHighestTemp = weatherDataList[1]["daily"][0]["temp"]["max"].toInt();
    forecastDetails.dayPlusOneLowestTemp = weatherDataList[1]["daily"][0]["temp"]["min"].toInt();
    forecastDetails.dayPlusOneIcon = getWeatherIcon(weatherDataList[1]["daily"][0]["weather"][0]["id"]);

    // plus 2 day
    var plusTwoDayDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["daily"][1]["dt"] * 1000);
    forecastDetails.dayPlusTwo = "${dayToString[plusTwoDayDate.weekday]}";
    forecastDetails.dayPlusTwoHighestTemp = weatherDataList[1]["daily"][1]["temp"]["max"].toInt();
    forecastDetails.dayPlusTwoLowestTemp = weatherDataList[1]["daily"][1]["temp"]["min"].toInt();
    forecastDetails.dayPlusTwoIcon = getWeatherIcon(weatherDataList[1]["daily"][1]["weather"][0]["id"]);

    // plus 1 day
    var plusThreeDayDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["daily"][2]["dt"] * 1000);
    forecastDetails.dayPlusThree = "${dayToString[plusThreeDayDate.weekday]}";
    forecastDetails.dayPlusThreeHighestTemp = weatherDataList[1]["daily"][2]["temp"]["max"].toInt();
    forecastDetails.dayPlusThreeLowestTemp = weatherDataList[1]["daily"][2]["temp"]["min"].toInt();
    forecastDetails.dayPlusThreeIcon = getWeatherIcon(weatherDataList[1]["daily"][2]["weather"][0]["id"]);

    // plus 1 day
    var plusFourDayDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["daily"][3]["dt"] * 1000);
    forecastDetails.dayPlusFour = "${dayToString[plusFourDayDate.weekday]}";
    forecastDetails.dayPlusFourHighestTemp = weatherDataList[1]["daily"][3]["temp"]["max"].toInt();
    forecastDetails.dayPlusFourLowestTemp = weatherDataList[1]["daily"][3]["temp"]["min"].toInt();
    forecastDetails.dayPlusFourIcon = getWeatherIcon(weatherDataList[1]["daily"][3]["weather"][0]["id"]);

    // plus 1 day
    var plusFiveDayDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["daily"][4]["dt"] * 1000);
    forecastDetails.dayPlusFive = "${dayToString[plusFiveDayDate.weekday]}";
    forecastDetails.dayPlusFiveHighestTemp = weatherDataList[1]["daily"][4]["temp"]["max"].toInt();
    forecastDetails.dayPlusFiveLowestTemp = weatherDataList[1]["daily"][4]["temp"]["min"].toInt();
    forecastDetails.dayPlusFiveIcon = getWeatherIcon(weatherDataList[1]["daily"][4]["weather"][0]["id"]);

    // plus 1 day
    var plusSixDayDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["daily"][5]["dt"] * 1000);
    forecastDetails.dayPlusSix = "${dayToString[plusSixDayDate.weekday]}";
    forecastDetails.dayPlusSixHighestTemp = weatherDataList[1]["daily"][5]["temp"]["max"].toInt();
    forecastDetails.dayPlusSixLowestTemp = weatherDataList[1]["daily"][5]["temp"]["min"].toInt();
    forecastDetails.dayPlusSixIcon = getWeatherIcon(weatherDataList[1]["daily"][5]["weather"][0]["id"]);

    // plus 1 day
    var plusSevenDayDate = DateTime.fromMillisecondsSinceEpoch(weatherDataList[1]["daily"][6]["dt"] * 1000);
    forecastDetails.dayPlusSeven = "${dayToString[plusSevenDayDate.weekday]}";
    forecastDetails.dayPlusSevenHighestTemp = weatherDataList[1]["daily"][6]["temp"]["max"].toInt();
    forecastDetails.dayPlusSevenLowestTemp = weatherDataList[1]["daily"][6]["temp"]["min"].toInt();
    forecastDetails.dayPlusSevenIcon = getWeatherIcon(weatherDataList[1]["daily"][6]["weather"][0]["id"]);

    return forecastDetails;
  }
}

class ForecastDetails {

  int temperature = 0;
  IconData currentIcon = WeatherIcons.alien;
  Color currentIconColor = Colors.purple;
  String cityName = "Unknown";
  String countryName = "Unknown";
  String dayType = "Unknown";
  int highestTemp = 0;
  int lowestTemp = 0;
  int feelsTemp = 0;
  String sunriseTime = "00:00";
  String sunsetTime = "00:00";
  String windSpeed = "0";
  int rainChance = 0;
  int uvRate = 0;
  int humidityRate = 0;
  String singleLineComment = "Error: No Location found.";
  String today = "Unknown";
  String date = "00 Unk";

  // Hourly
  int hourPlusOneTemp = 0;
  int hourPlusTwoTemp = 0;
  int hourPlusThreeTemp = 0;
  int hourPlusFourTemp = 0;
  int hourPlusFiveTemp = 0;
  String hourPlusOne = "00:00";
  String hourPlusTwo = "00:00";
  String hourPlusThree = "00:00";
  String hourPlusFour = "00:00";
  String hourPlusFive = "00:00";
  IconData hourPlusOneIcon = WeatherIcons.alien;
  IconData hourPlusTwoIcon = WeatherIcons.alien;
  IconData hourPlusThreeIcon = WeatherIcons.alien;
  IconData hourPlusFourIcon = WeatherIcons.alien;
  IconData hourPlusFiveIcon = WeatherIcons.alien;

  // Daily
  // String dayPlusOne = "Unknown"; // Use Tomorrow instead
  int dayPlusOneHighestTemp = 0;
  int dayPlusOneLowestTemp = 0;
  IconData dayPlusOneIcon = WeatherIcons.alien;

  String dayPlusTwo = "Unknown";
  int dayPlusTwoHighestTemp = 0;
  int dayPlusTwoLowestTemp = 0;
  IconData dayPlusTwoIcon = WeatherIcons.alien;

  String dayPlusThree = "Unknown";
  int dayPlusThreeHighestTemp = 0;
  int dayPlusThreeLowestTemp = 0;
  IconData dayPlusThreeIcon = WeatherIcons.alien;

  String dayPlusFour = "Unknown";
  int dayPlusFourHighestTemp = 0;
  int dayPlusFourLowestTemp = 0;
  IconData dayPlusFourIcon = WeatherIcons.alien;

  String dayPlusFive = "Unknown";
  int dayPlusFiveHighestTemp = 0;
  int dayPlusFiveLowestTemp = 0;
  IconData dayPlusFiveIcon = WeatherIcons.alien;

  String dayPlusSix = "Unknown";
  int dayPlusSixHighestTemp = 0;
  int dayPlusSixLowestTemp = 0;
  IconData dayPlusSixIcon = WeatherIcons.alien;

  String dayPlusSeven = "Unknown";
  int dayPlusSevenHighestTemp = 0;
  int dayPlusSevenLowestTemp = 0;
  IconData dayPlusSevenIcon = WeatherIcons.alien;

}
