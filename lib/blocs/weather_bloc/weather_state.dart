part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object> get props => [];
}

class LoadingState extends WeatherState{

}

class LoadedState extends WeatherState{
  final Weather weather;
  final VisibilityStatus visibilityStatus;

  const LoadedState(this.weather, this.visibilityStatus);
}

class ErrorState extends WeatherState{
  final String errorText;

  const ErrorState(this.errorText);
}
