import 'services/app.dart';
import 'services/city_catalog.dart';
import 'services/images.dart';
import 'services/favorite_city.dart';
import 'services/weather_info.dart';



abstract class Global
{
  static late final AppService app;
  static late final FaviriteCityService favoriteCity;
  static late final ImagesService images;
  static late final CityCatalogService cityCatalog;
  static late final WeatherInfoService weatherInfo;

  static void init()
  {
    app = AppService();
    favoriteCity = FaviriteCityService();
    images = const ImagesService();
    cityCatalog = CityCatalogService();
    weatherInfo = WeatherInfoService();
  }
}
