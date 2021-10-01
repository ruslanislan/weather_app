import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/api_service.dart';

class WeatherService {
  final ApiService _apiService = ApiService();

  Future<Weather> getWeather(Position? position) async {
    final data = await _apiService.get(
        "/data/2.5/onecall", {'lat': position?.latitude ?? 59.600121, 'lon': position?.longitude ?? 55.204849, "exclude": "minutely", "appid": "371acc8df22c80ef6aed4112839027e3"});
    return Weather.fromJson(data);
  }
}
