import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/daily.dart';
import 'package:weather_app/services/app_localizations.dart';

import 'custom_tile.dart';

class DailyContainer extends StatelessWidget {
  const DailyContainer({Key? key, required this.daily, required this.name}) : super(key: key);
  final String name;
  final Daily daily;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Column(
        children: [
          Expandable(
            collapsed: ExpandableButton(
              child: _CollapsedBody(
                name: name,
                daily: daily,
              ),
            ),
            expanded: Column(children: [
              ExpandableButton(
                child: _CollapsedBody(
                  isExpanded: true,
                  name: name,
                  daily: daily,
                ),
              ),
              _ExpandedBody(
                daily: daily,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _CollapsedBody extends StatelessWidget {
  const _CollapsedBody({Key? key, this.isExpanded = false, required this.daily, required this.name}) : super(key: key);
  final bool isExpanded;
  final String name;
  final Daily daily;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(10),
          bottom: isExpanded ? Radius.zero : const Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.all(15),
      height: 160,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: ((daily.temp.day - 273).toInt()).toString(),
                      style: const TextStyle(
                        fontSize: 70,
                        color: Color(0xFF2c3a41),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: "°",
                      style: TextStyle(
                        fontSize: 70,
                        color: Color(0xFF96cad7),
                      ),
                    ),
                  ])),
                  Text(
                    AppLocalizations.of(context)!.translate(daily.weather[0].main).toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFf76a85),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    name.replaceAll("/", ",").toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF8dc6d3),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Image(
                image: CachedNetworkImageProvider(
                  "http://openweathermap.org/img/wn/${daily.weather[0].icon}@2x.png",
                ),
                fit: BoxFit.cover,
              )),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFf9738c),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          "assets/png/humidity.png",
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${daily.humidity}%",
                        style: const TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  DateTime.fromMillisecondsSinceEpoch(daily.dt * 1000).day.toString(),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFcbe4eb),
                    height: 0.8,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.translate(DateFormat("E").format(DateTime.fromMillisecondsSinceEpoch(daily.dt * 1000)).toString()),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF95c7d6),
                    height: 0.8,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ExpandedBody extends StatelessWidget {
  const _ExpandedBody({Key? key, required this.daily}) : super(key: key);
  final Daily daily;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          const Divider(
            height: 1,
          ),
          CustomTile(
            value: "${(daily.temp.morn - 273).toInt()}°",
            text: AppLocalizations.of(context)!.translate('morn'),
          ),
          const Divider(
            height: 1,
          ),
          CustomTile(
            value: "${(daily.temp.day - 273).toInt()}°",
            text: AppLocalizations.of(context)!.translate('day'),
          ),
          const Divider(
            height: 1,
          ),
          CustomTile(
            value: "${(daily.temp.eve - 273).toInt()}°",
            text: AppLocalizations.of(context)!.translate('eve'),
          ),
          const Divider(
            height: 1,
          ),
          CustomTile(
            value: "${(daily.temp.night - 273).toInt()}°",
            text: AppLocalizations.of(context)!.translate('night'),
          ),
          const Divider(
            height: 1,
          ),
          CustomTile(
            value: DateFormat("Hm").format(DateTime.fromMillisecondsSinceEpoch(daily.sunrise * 1000)).toUpperCase(),
            text: AppLocalizations.of(context)!.translate('sunrise'),
          ),
          const Divider(
            height: 1,
          ),
          CustomTile(
            value: DateFormat("Hm").format(DateTime.fromMillisecondsSinceEpoch(daily.sunset * 1000)).toUpperCase(),
            text: AppLocalizations.of(context)!.translate('sunset'),
          ),
          const Divider(
            height: 1,
          ),
          CustomTile(
            value: daily.uvi.toString(),
            isLast: true,
            text: AppLocalizations.of(context)!.translate('uvi'),
          ),
        ],
      ),
    );
  }
}
