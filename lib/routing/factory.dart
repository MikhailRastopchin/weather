import 'package:flutter/material.dart';

import '../models.dart';
import '../pages/city_selection.dart';
import '../pages/home.dart';
import '../pages/loader.dart';
import '../pages/loader_state.dart';
import '../pages/welcome.dart';
import 'routes.dart';


class UnknownRouteException implements Exception
{
  final String? route;

  const UnknownRouteException(this.route);

  @override
  String toString() => 'Could not dispatch the route $route';
}


typedef PageBuilder = Widget Function();


class RoutesFactory
{
  final Function(LoaderState) onLoading;

  const RoutesFactory(this.onLoading);

  Route<dynamic> call(final RouteSettings settings)
  {
    switch (settings.name) {
      case Routes.loader:
        return getGenericRoute(settings, () => LoaderPage(onLoading));
      case Routes.home:
        return getGenericRoute(settings,
          () => const HomePage()
        );
      case Routes.citySelection:
        return getGenericRoute<City>(settings,
          () => const CitySelectionPage(),
        );
      case Routes.welcome:
        return getGenericRoute(settings,
          () => WelcomePage(settings.arguments! as WelcomePageArgs),
        );
    }
    throw(UnknownRouteException(settings.name));
  }

  Route<T> getGenericRoute<T>(
    final RouteSettings settings,
    final PageBuilder builder,
  )
  {
    return MaterialPageRoute<T>(
      builder: (context) => builder(),
      settings: settings,
    );
  }
}
