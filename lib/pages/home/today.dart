import 'package:flutter/material.dart';

import '../today_weather.dart';


class TodayWeatherView extends StatefulWidget
{
  const TodayWeatherView({Key? key}) : super(key: key);

  @override
  State<TodayWeatherView> createState() => _TodayWeatherViewState();
}


class _TodayWeatherViewState extends State<TodayWeatherView>
  with AutomaticKeepAliveClientMixin
{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(final BuildContext context)
  {
    super.build(context);
    return const TodayWeatherPage();
  }
}
