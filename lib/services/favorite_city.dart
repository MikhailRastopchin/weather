import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../utils/file_system.dart';
import '../models.dart';


final _log = Logger('Storage');


class FaviriteCityService extends ChangeNotifier
{
  bool get initialized => _initialized;

  City? get city => _city;

  Future<void> setCity(final City? value) async
  {
    if (_city == value) return;
    _city = value;
    await _saveCity();
    notifyListeners();
  }

  Future<void> init() async
  {
    _storagePath = await getFilesPath(path: 'city', create: true);
    await _loadCity();
    _initialized = true;
  }

  Future<void> _loadCity() async
  {
    final jsonValue = await loadJson(_cityPath);
    if (jsonValue == null) {
      _log.info('No city in the local storage.');
    } else {
      setCity(City.fromJson(jsonValue));
      _log.info('City loaded from the local storage.');
    }
    notifyListeners();
  }

  Future<void> _saveCity() async
  {
    await saveJson(_cityPath, _city);
    _log.info('City saved in the local storage.');
  }

  String get _cityPath => '$_storagePath/cities.json';

  String? _storagePath;

  bool _initialized = false;

  City? _city;
}