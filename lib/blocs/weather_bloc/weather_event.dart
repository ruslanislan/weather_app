part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class LoadingEvent extends WeatherEvent{
  final VisibilityStatus visibilityStatus;
  final BuildContext context;
  const LoadingEvent({required this.visibilityStatus, required this.context});
}