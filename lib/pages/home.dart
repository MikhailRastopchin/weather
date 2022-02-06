import 'package:flutter/material.dart';
import 'package:weather/pages/common/styles.dart';

import '../global.dart';
import '../routing.dart';
import 'home/current.dart';
import 'home/today.dart';
import 'home/daily.dart';


class HomePage extends StatefulWidget
{
  const HomePage({ final Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>
  with SingleTickerProviderStateMixin
{
  @override
  void initState()
  {
    super.initState();
    _viewController = PageController();
    Global.app.setLoaded();
  }

  @override
  void dispose()
  {
    _viewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return WillPopScope(
      onWillPop: () async {
        Routing.hideToasts();
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar,
        body: PageView(
          controller: _viewController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            CurrentWeatherView(),
            TodayWeatherView(),
            DailyForecastView(),
          ],
        ),
      ),
    );
  }

  Widget get bottomNavigationBar
  {
    const padding = EdgeInsets.only(top: 8.0, bottom: 4.0);
    final theme = Theme.of(context);
    final selectedItemStyle = theme.textTheme.button!.copyWith(
      color: AppStyle.liteColors.buttonColor,
    );
    final unSelectedItemStyle = theme.textTheme.button!.copyWith(
      color: AppStyle.liteColors.primaryDarkColor,
    );
    return BottomNavigationBar(
      key: _bottomBarKey,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      currentIndex: _viewIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: padding,
            child: Text('Сейчас', style: unSelectedItemStyle),
          ),
          activeIcon: Padding(
            padding: padding,
            child: Text('Сейчас', style: selectedItemStyle),
          ),
          label: 'Сейчас',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: padding,
            child: Text('На сутки', style: unSelectedItemStyle),
          ),
          activeIcon: Padding(
            padding: padding,
            child: Text('На сутки', style: selectedItemStyle),
          ),
          label: 'На сутки',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: padding,
            child: Text('На неделю', style: unSelectedItemStyle),
          ),
          activeIcon: Padding(
            padding: padding,
            child: Text('На неделю', style: selectedItemStyle),
          ),
          label: 'На неделю',
        ),
      ],
      onTap: _setView,
    );
  }

  void _setView(final int index)
  {
    if (_viewIndex == index) return;
    setState(() {
      _viewIndex = index;
      _viewController.jumpToPage(index);
    });
  }

  int _viewIndex = 0;
  late final PageController _viewController;

  final _bottomBarKey = GlobalKey();
}
