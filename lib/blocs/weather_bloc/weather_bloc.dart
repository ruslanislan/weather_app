import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/models/enums/visibility_status.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  Weather? weather;
  var box = Hive.openBox("weather");
  final WeatherService _weatherService = WeatherService();

  WeatherBloc() : super(LoadingState()) {
    on<WeatherEvent>((event, emit) async {
      var box = await Hive.openBox("weather");
      if (event is LoadingEvent) {
        emit(LoadingState());
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          weather = Weather.fromJson(box.get("forecast"));
        } else {
          try {
            Position? position = await _determinePosition();
            weather = await _weatherService.getWeather(position);
            box.delete("forecast");
            box.put("forecast", weather!.toJson());
            emit(LoadedState(weather!, event.visibilityStatus));
          } catch (ex) {
            emit(ErrorState(ex.toString()));
          }
          weather = await _weatherService.getWeather(null);
          box.put("forecast", weather!.toJson());

          Future.wait(weather!.daily
              .map((e) => precacheImage(
                  CachedNetworkImageProvider(
                    "http://openweathermap.org/img/wn/${e.weather[0].icon}@2x.png",
                  ),
                  event.context))
              .toList());

          Future.wait(weather!.hourly
              .map((e) => precacheImage(
                  CachedNetworkImageProvider(
                    "http://openweathermap.org/img/wn/${e.weather[0].icon}@2x.png",
                  ),
                  event.context))
              .toList());
        }

        emit(LoadedState(weather!, event.visibilityStatus));
      }
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

Future<Position?> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
