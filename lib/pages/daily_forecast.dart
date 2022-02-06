import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/favorite_city.dart';

import '../services/weather_info.dart';
import '../models.dart';
import '../routing.dart';
import 'common/styles.dart';


class DailyForecastPage extends StatefulWidget
{
  const DailyForecastPage({Key? key}) : super(key: key);

  @override
  State<DailyForecastPage> createState() => _DailyForecastPageState();
}


class _DailyForecastPageState extends State<DailyForecastPage>
  with TickerProviderStateMixin
{
  @override
  void dispose()
  {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context)
  {
    final weatherInfoService = context.watch<WeatherInfoService>();
    final cityService = context.watch<FaviriteCityService>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Прогноз на неделю в ${cityService.city!.name}'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => weatherInfoService.getWeather(cityService.city!),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppStyle.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              child:  Text('Изменить город',
                style: theme.textTheme.button!.copyWith(
                  color: AppStyle.liteColors.headerTextColor,
                ),
              ),
              onPressed: _changeCity,
            ),
            Expanded(
              child: weatherInfoService.info == null
                ? Center(child: weatherInfoService.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Данных о погоде нет'),
                  )
                : content,
            ),
          ],
        ),
      ),
    );
  }

  Widget get content
  {
    const locale = Locale('ru', 'RU');
    final localeName = Intl.canonicalizedLocale(locale.toString());
    final weatherInfoService = context.watch<WeatherInfoService>();
    final forecasts = weatherInfoService.info!.dailyForecasts;
    if (_tabController == null) {
      _tabController = TabController(
      length: forecasts.length,
      vsync: this
    )..addListener(_onTabChanged);
    } else if (_tabController!.length != forecasts.length) {
      _tabController!.dispose();
      _tabController = TabController(
        length: forecasts.length,
        vsync: this,
        initialIndex: min(_selectedTabIndex ?? 0, forecasts.length - 1),
      )..addListener(_onTabChanged);
    }
    final tabs = <Widget>[];
    final tabViews = <Widget>[];
    final formatter = DateFormat.yMd(localeName);
    for (var forecast in forecasts) {
      tabs.add(Tab(text: formatter.format(forecast.forecastedTo)));
      tabViews.add(_WeatherForecastView(forecast,
        key: ValueKey(forecast.forecastedTo),
      ));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TabBar(tabs: tabs, controller: _tabController, isScrollable: true),
        ),
        Expanded(child: TabBarView(
          children: tabViews,
          controller: _tabController,
        )),
      ]
    );
  }

  Future<void> _changeCity() async
  {
    final cityService = context.read<FaviriteCityService>();
    final weatherInfoService = context.read<WeatherInfoService>();
    final newCity = await Routing.showCitySelection(context);
    if (newCity != null) {
      await cityService.setCity(newCity);
      weatherInfoService.getWeather(newCity);
    }
  }

  void _onTabChanged() => _selectedTabIndex = _tabController!.index;

  TabController? _tabController;

  int? _selectedTabIndex;
}


class _WeatherForecastView extends StatefulWidget
{
  final DailyForecast forecast;

  const _WeatherForecastView(this.forecast, { final Key? key}) : super(key: key);

  @override
  State<_WeatherForecastView> createState() => _WeatherForecastViewState();
}


class _WeatherForecastViewState extends State<_WeatherForecastView>
  with AutomaticKeepAliveClientMixin
{
  @override
  bool get wantKeepAlive => true;

  DailyForecast get forecast => widget.forecast;

  @override
  Widget build(final BuildContext context)
  {
    super.build(context);
    final theme = Theme.of(context);
    final pressure = (forecast.pressure * 0.750062).floor();
    final formatter = DateFormat.Hms();
    final weatherCondition = Row(
        children: [
          Text('${forecast.temperature.day} \u{2103}',
            style: theme.textTheme.headline4!.copyWith(
              color: theme.colorScheme.onBackground
            ),
          ),
          Expanded(child: Column(
            children: [
              Text(forecast.weather.first.main, style: theme.textTheme.headline6),
              Text(forecast.weather.first.description!),
            ],
          )),
          Image.network(_imageUrl(forecast.weather.first.icon!)),
        ],
      );
    final content = [
      weatherCondition,
      const Divider(),
      _buildMainEntry('Температура', '${forecast.temperature.day} \u{2103}'),
      const Divider(),
      _buildMainEntry('Ощущается как', '${forecast.feelsLike.day} \u{2103}'),
      const Divider(),
      _buildMainEntry('Влажность', '${forecast.humidity} %'),
      const Divider(),
      _buildMainEntry('Точка росы', '${forecast.dewPoint} \u{2103}'),
      const Divider(),
      _buildMainEntry('Атмосферное давление', '$pressure мм.рт.ст.'),
      const Divider(),
      _buildMainEntry('Ультрафиолетовый индекс', '${forecast.uvi}'),
      const Divider(thickness: 3.0),
      _buildMainEntry('Облачность', '${forecast.cloudiness} %'),
      const Divider(),
      _buildMainEntry('Вероятность осадков', '${forecast.pop} %'),
      const Divider(thickness: 3.0),
      _buildMainEntry('Скорость ветра', '${forecast.windSpeed} м/с'),
      const Divider(),
      _buildMainEntry('С порывами до', '${forecast.windGust} м/с.'),
      const Divider(thickness: 3.0),
      _buildMainEntry('Восход солнца', formatter.format(forecast.sunrise)),
      const Divider(),
      _buildMainEntry('Закат солнца', formatter.format(forecast.sunset)),
      const Divider(thickness: 3.0),
      _buildMainEntry('Восход луны', formatter.format(forecast.moonrise)),
      const Divider(),
      _buildMainEntry('Закат луны', formatter.format(forecast.moonset)),
    ];
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: content,
          ),
        ),
      ),
    );
  }

  Widget _buildMainEntry(final String caption, final String value)
  {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text('$caption:', style: theme.textTheme.bodyText1),
        const SizedBox(width: 10.0),
        Expanded(child: Text(value, textAlign: TextAlign.end)),
      ],
    );
  }

  String _imageUrl(final String image)
    => 'http://openweathermap.org/img/w/$image.png';
}
