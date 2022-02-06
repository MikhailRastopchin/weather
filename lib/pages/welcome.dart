import 'package:flutter/material.dart';
import 'package:weather/global.dart';
import 'package:weather/routing/router.dart';

import '../models/city.dart';
import 'common/styles.dart';


class WelcomePageArgs
{
  final Function(BuildContext, City) onDone;

  const WelcomePageArgs(this.onDone);
}


class WelcomePage extends StatelessWidget
{
  final WelcomePageArgs arguments;

  const WelcomePage(this.arguments, { final Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Добро пожаловать в приложение\nПогода!',
                style: theme.textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0.0, 60.0),
                  primary: AppStyle.liteColors.buttonColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))
                  ),
                ),
                child: const Text('Выбрать город'),
                onPressed: () => _selectCity(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectCity(final BuildContext context) async
  {
    final newCity = await Routing.showCitySelection(context);
    if (newCity != null) {
      Global.favoriteCity.setCity(newCity);
      arguments.onDone(context, newCity);
    }
  }
}