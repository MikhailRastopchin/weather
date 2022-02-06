import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/favorite_city.dart';

import '../services/weather_info.dart';
import '../models.dart';
import '../routing.dart';
import 'common/styles.dart';


class CurrentWeatherPage extends StatefulWidget
{
  const CurrentWeatherPage({Key? key}) : super(key: key);

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}


class _CurrentWeatherPageState extends State<CurrentWeatherPage>
  with TickerProviderStateMixin
{
  @override
  Widget build(final BuildContext context)
  {
    final weatherInfoService = context.watch<WeatherInfoService>();
    final cityService = context.watch<FaviriteCityService>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Сейчас в ${cityService.city!.name}'),
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
                : _buildContent(weatherInfoService.info!.currentWeather),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(final Weather weather)
  {
    final theme = Theme.of(context);
    final pressure = (weather.pressure * 0.750062).floor();
    final formatter = DateFormat.Hms();
    final weatherCondition = Row(
        children: [
          Text('${weather.temperature} \u{2103}',
            style: theme.textTheme.headline4!.copyWith(
              color: theme.colorScheme.onBackground
            ),
          ),
          Expanded(child: Column(
            children: [
              Text(weather.weather.first.main, style: theme.textTheme.headline6),
              Text(weather.weather.first.description!),
            ],
          )),
          Image.network(_imageUrl(weather.weather.first.icon!)),
        ],
      );
    final content = [
      weatherCondition,
      const Divider(),
      _buildMainEntry('Ощущается как', '${weather.feelsLike} \u{2103}'),
      const Divider(),
      _buildMainEntry('Влажность', '${weather.humidity} %'),
      const Divider(),
      _buildMainEntry('Точка росы', '${weather.dewPoint} \u{2103}'),
      const Divider(),
      _buildMainEntry('Атмосферное давление', '$pressure мм.рт.ст.'),
      const Divider(),
      _buildMainEntry('Ультрафиолетовый индекс', '${weather.uvi}'),
      const Divider(thickness: 3.0),
      _buildMainEntry('Облачность', '${weather.cloudiness} %'),
      const Divider(),
      _buildMainEntry('Вероятность осадков', '${weather.pop} %'),
      const Divider(thickness: 3.0),
      _buildMainEntry('Скорость ветра', '${weather.windSpeed} м/с'),
      const Divider(),
      _buildMainEntry('С порывами до', '${weather.windGust} м/с.'),
      if (weather.sunrise != null) const Divider(thickness: 3.0),
      if (weather.sunrise != null) _buildMainEntry(
        'Восход солнца',
        formatter.format(weather.sunrise!)
      ),
      if (weather.sunset != null) const Divider(),
      if (weather.sunset != null) _buildMainEntry(
        'Закат солнца',
        formatter.format(weather.sunset!),
      ),
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

  String _imageUrl(final String image)
    => 'http://openweathermap.org/img/w/$image.png';
}
