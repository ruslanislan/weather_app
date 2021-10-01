import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:weather_app/models/enums/visibility_status.dart';

class ChangeStatusButton extends StatelessWidget {
  const ChangeStatusButton({Key? key, this.visible = false}) : super(key: key);

  final bool visible;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyText2;
    final activeStyle = Theme.of(context).textTheme.bodyText2?.copyWith(color: Theme.of(context).accentColor);
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state){
      final button = _Button(
        defaultStyle: defaultStyle,
        onSelected: (filter) {
          context.read<WeatherBloc>().add(LoadingEvent(visibilityStatus: filter, context: context));
        },
        activeStyle: activeStyle,
        activeFilter:(state is LoadedState) ? (state).visibilityStatus : VisibilityStatus.hourly,
      );
      return AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: visible
            ? button
            : IgnorePointer(
          child: button,
        ),
      );
    });
  }
}

class _Button extends StatelessWidget {
  const _Button({Key? key, required this.onSelected, required this.activeFilter, required this.activeStyle, required this.defaultStyle}) : super(key: key);

  final PopupMenuItemSelected<VisibilityStatus> onSelected;
  final VisibilityStatus activeFilter;
  final TextStyle? activeStyle;
  final TextStyle? defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VisibilityStatus>(
      tooltip: "Change Mode Forecast",
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<VisibilityStatus>>[
        PopupMenuItem(
          value: VisibilityStatus.hourly,
          child: Text(
            "Show Hourly",
            style: activeFilter == VisibilityStatus.hourly ? activeStyle : defaultStyle,
          ),
        ),
        PopupMenuItem(
          value: VisibilityStatus.daily,
          child: Text(
            'Show Daily',
            style: activeFilter == VisibilityStatus.daily ? activeStyle : defaultStyle,
          ),
        ),
      ],
      icon: const Icon(Icons.filter_list),
    );
  }
}
