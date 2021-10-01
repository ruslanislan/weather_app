import 'package:dio/dio.dart';

class ApiService {
  static const _defaultUrl = "https://api.openweathermap.org";

  Dio dio = Dio(BaseOptions(baseUrl: _defaultUrl));

  get(String path, dynamic query) async {
    final response = await dio.get(path, queryParameters: query);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to load get");
    }
  }
}
