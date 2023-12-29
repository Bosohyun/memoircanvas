import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class Weather {
  static const sunny = 'sunny';
  static const cloudy = 'cloudy';
  static const rainy = 'rainy';
  static const snowy = 'snowy';
  static const foggy = 'foggy';
  static const windy = 'windy';
  static const thunderstorm = 'thunderstorm';

  get sunnyIcon => WeatherIcons.day_sunny;
  get cloudyIcon => WeatherIcons.cloudy;
  get rainyIcon => WeatherIcons.rain;
  get snowyIcon => WeatherIcons.snow;
  get foggyIcon => WeatherIcons.fog;
  get windyIcon => WeatherIcons.strong_wind;
  get thunderstormIcon => WeatherIcons.thunderstorm;
}

extension WeatherExtension on Weather {
  IconData getIcon(String weather) {
    switch (weather) {
      case Weather.sunny:
        return sunnyIcon;
      case Weather.cloudy:
        return cloudyIcon;
      case Weather.rainy:
        return rainyIcon;
      case Weather.snowy:
        return snowyIcon;
      case Weather.foggy:
        return foggyIcon;
      case Weather.windy:
        return windyIcon;
      case Weather.thunderstorm:
        return thunderstormIcon;
      default:
        return sunnyIcon;
    }
  }
}
