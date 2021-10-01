import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:weather_app/models/enums/visibility_status.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/app_localizations.dart';
import 'package:weather_app/widgets/widgets.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFe6eef1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9fcfdb),
        title: const Text('Weather App'),
        actions: const [
          ChangeStatusButton(
            visible: true,
          ),
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ErrorState) {
            return Center(
              child: Text(state.errorText),
            );
          }
          if (state is LoadedState) {
            if(state.visibilityStatus == VisibilityStatus.hourly) {
              return _HourlyListBody(data: state.weather);
            }
            return _DailyListBody(data: state.weather);
          }
          return Container();
        },
      ),
    );
  }
}

class _HourlyListBody extends StatelessWidget {
  const _HourlyListBody({Key? key, required this.data}) : super(key: key);
  final Weather data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: List.generate(
          (24),
          (index) => Column(
            children: [
              if (index == 0)
                const SizedBox(
                  height: 8,
                ),
              CustomTile2(
                icon: Image(image: CachedNetworkImageProvider("http://openweathermap.org/img/wn/${data.hourly[index].weather[0].icon}@2x.png",),),
                isFirst: index == 0,
                isLast: index == 23,
                text: DateFormat("Hm").format(
                  DateTime.fromMillisecondsSinceEpoch(data.hourly[index].dt * 1000),
                ),
                value: (data.hourly[index].temp - 273).toInt().toString() + "°",
                description: AppLocalizations.of(context)!.translate(data.hourly[index].weather[0].main),
              ),
              if (index != 23)
                const Divider(
                  height: 1,
                ),
              if (index == 23)
                const SizedBox(
                  height: 10,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyListBody extends StatelessWidget {
  const _DailyListBody({Key? key, required this.data}) : super(key: key);
  final Weather data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: List.generate(
          data.daily.length,
          (index) => Column(
            children: [
              if (index == 0)
                const SizedBox(
                  height: 6,
                ),
              DailyContainer(
                daily: data.daily[index],
                name: data.timezone,
              ),
              const SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
