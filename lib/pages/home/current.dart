import 'package:flutter/material.dart';

import '../current_weather.dart';


class CurrentWeatherView extends StatefulWidget
{
  const CurrentWeatherView({Key? key}) : super(key: key);

  @override
  State<CurrentWeatherView> createState() => _CurrentWeatherViewState();
}


class _CurrentWeatherViewState extends State<CurrentWeatherView>
  with AutomaticKeepAliveClientMixin
{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(final BuildContext context)
  {
    super.build(context);
    return const CurrentWeatherPage();
  }
}
