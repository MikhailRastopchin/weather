import 'dart:async' show Future;
import 'dart:convert' as convert;

import 'package:flutter/services.dart' show rootBundle;

import '../models.dart';


class CityCatalogService
{
  bool get initialized => _initialized;

  List<City> get cities => _cities;

  Future<void> init() async
  {
    _cities = await _loadCities();
    _initialized = true;
  }

  Future<List<City>> _loadCities() async
  {
    var jsonText = await rootBundle.loadString('assets/cities.json');
    final jsonCities = convert.jsonDecode(jsonText) as List;
    final cities = <City>[];
    for (var jsonCity in jsonCities) {
      final city = City.fromJson(jsonCity);
      cities.add(city);
    }
    return cities;
  }

  late final List<City> _cities;

  bool _initialized = false;
}