import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:weather/services/favorite_city.dart';
import 'package:weather/services/weather_info.dart';
import 'package:provider/provider.dart';

import 'global.dart';
import 'routing/router.dart';
import 'routing/factory.dart';
import 'routing/routes.dart';
import 'pages/common/styles.dart';
import 'pages/loader_state.dart';


class MyApp extends StatefulWidget
{
  const MyApp({ final Key? key }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}


class MyAppState extends State<MyApp> with WidgetsBindingObserver
{
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    Global.app.state = WidgetsBinding.instance?.lifecycleState;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      background: AppStyle.liteColors.backgroundColor,
      surface: AppStyle.liteColors.cardColor,
      primary: AppStyle.liteColors.primaryColor,
      primaryVariant: AppStyle.liteColors.primaryDarkColor,
      secondary: AppStyle.liteColors.secondaryColor,
      secondaryVariant: AppStyle.liteColors.secondaryColor,
      error: AppStyle.liteColors.errorColor,
      onBackground: const Color(0xff000000),
      onSurface: const Color(0xff000000),
      onPrimary: const Color(0xffffffff),
      onSecondary: const Color(0xff000000),
      onError: const Color(0xffffffff),
    );
    _themeData = ThemeData(
      colorScheme: colorScheme,
      primarySwatch: Colors.grey,
      primaryColor: colorScheme.primary,
      canvasColor: colorScheme.background,
      cardColor: colorScheme.surface,
      backgroundColor: AppStyle.liteColors.backgroundColor,
      indicatorColor: colorScheme.primary,
      errorColor: AppStyle.liteColors.errorColor,
      hoverColor: AppStyle.liteColors.linksColor,
      dividerColor: AppStyle.liteColors.dividerColor,
      primaryTextTheme: const TextTheme(
      ),
      textTheme: const TextTheme(
        button: TextStyle(fontSize: 16.0),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.secondary,
        selectionColor: colorScheme.secondary,
        selectionHandleColor: colorScheme.secondary,
      ),
      toggleableActiveColor: colorScheme.primary,
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        border: const UnderlineInputBorder(),
        errorStyle: TextStyle(
          fontSize: 12.0,
          color: AppStyle.liteColors.errorColor,
        ),
        counterStyle: const TextStyle(fontSize: 12.0),
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
        centerTitle: false,
        titleSpacing: 2.0,
      ),
      tabBarTheme: const TabBarTheme(
        labelStyle: AppStyle.tabStyle,
        unselectedLabelStyle: AppStyle.inactiveTabStyle,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppStyle.liteColors.backgroundColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: const Color(0xff6d6d6d),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppStyle.liteColors.buttonColor,
        height: 42.0,
        shape: const RoundedRectangleBorder(),
        textTheme: ButtonTextTheme.primary,
        alignedDropdown: false,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: colorScheme.onBackground,
          textStyle: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          )
        )
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: AppStyle.liteColors.buttonColor,
          textStyle: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          )
        ),
      ),
      dialogTheme: DialogTheme(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        backgroundColor: colorScheme.surface,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
        )),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
    _routesFactory = RoutesFactory(_onLoading);
  }

  @override
  Widget build(final BuildContext context)
  {
    final app = MaterialApp(
      onGenerateTitle: (context) => 'Погода в России',
      onGenerateRoute: _routesFactory,
      theme: _themeData,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: Routes.loader,
    );
    return StyledToast(
      locale: const Locale('ru', 'RU'),
      textStyle: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppStyle.liteColors.toastForeground,
      ),
      backgroundColor: AppStyle.liteColors.toastBackground,
      borderRadius: AppStyle.toasts.borderRadius,
      textPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      toastPositions: const StyledToastPosition(
        align: Alignment.bottomCenter, offset: 64.0
      ),
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
      duration: AppStyle.toasts.duration,
      animDuration: AppStyle.toasts.animDuration,
      dismissOtherOnShow: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<WeatherInfoService>(
            create: (_) => Global.weatherInfo,
          ),
          ChangeNotifierProvider<FaviriteCityService>(
            create: (_) => Global.favoriteCity,
          ),
        ],
        child: app
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)
    => Global.app.state = state;

  @override
  void dispose()
  {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  Future<void> _onLoading(final LoaderState state) async
  {
    state.message = 'Загрузка...';
    Future.delayed(const Duration(seconds: 5), () {
      state.supportVisible = true;
    });

    await Global.cityCatalog.init();
    await Global.favoriteCity.init();

    if (Global.favoriteCity.city == null) {
      Routing.showWelcome(state.context, (context, city) async {
        Global.weatherInfo.getWeather(city);
        Routing.replaceWith(context, Routes.home);
      });
    } else {
      Global.weatherInfo.getWeather(Global.favoriteCity.city!);
      Routing.replaceWith(state.context, Routes.home);
    }
  }

  late final ThemeData _themeData;
  late final RoutesFactory _routesFactory;
}
