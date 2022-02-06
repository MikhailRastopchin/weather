import 'package:flutter/material.dart';

import '../daily_forecast.dart';


class DailyForecastView extends StatefulWidget
{
  const DailyForecastView({Key? key}) : super(key: key);

  @override
  State<DailyForecastView> createState() => _DailyForecastViewState();
}


class _DailyForecastViewState extends State<DailyForecastView>
  with AutomaticKeepAliveClientMixin
{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(final BuildContext context)
  {
    super.build(context);
    return const DailyForecastPage();
  }
}
