import 'package:flutter/material.dart';

import '../global.dart';
import '../models.dart';
import '../routing/router.dart';
import 'common/styles.dart';


class CitySelectionPage extends StatefulWidget
{
  final Function(BuildContext, City)? onDone;

  const CitySelectionPage({ final Key? key, this.onDone }) : super(key: key);

  @override
  State<CitySelectionPage> createState() => _CitySelectionPageState();
}


class _CitySelectionPageState extends State<CitySelectionPage>
{
  set filter(final String value)
  {
    if (_filter == value) return;
    _filter = value;
    if (_filter!.isEmpty) {
      setState(() => _filterWords = const []);
      setState(() => _cities = Global.cityCatalog.cities);
    } else {
      _filterWords = _filter!
        .split(RegExp(r'\s+'))
        .map((word) => RegExp(word, caseSensitive: false))
        .toList();
      setState(() => _cities = Global.cityCatalog.cities
        .where((city) => _filterWords.every((word) => city.name.contains(word)))
        .toList());
    }
  }

  @override
  void initState()
  {
    super.initState();
    _cities = Global.cityCatalog.cities;
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
    _searchFocus.addListener(() {
      if (_searchFocus.hasFocus) return;
      filter = _searchController.text.trim();
    });
  }

  @override
  Widget build(final BuildContext context)
  {
    return Scaffold(
      body: Padding(
        padding: AppStyle.pagePadding,
        child: Column(
          children:[
            const SafeArea(child: SizedBox()),
            const SizedBox(height: 15.0),
            searchField,
            const SizedBox(height: 5.0),
            Expanded(child: ListView.builder(
              itemBuilder: (context, index) {
                final city = _cities[index];
                return ListTile(
                  title: Text(city.name),
                  onTap: () => _selectCity(city),
                );
              },
              itemCount: _cities.length,
            )),
          ],
        ),
      ),
    );
  }

  Widget get searchField
  {
    return TextField(
      decoration: InputDecoration(
        hintText: 'поиск',
        prefixIcon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.search),
        ),
        suffixIcon: _searchController.text.isEmpty
          ? null
          : IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.text = '';
                filter = _searchController.text;
              },
            ),
        border: const OutlineInputBorder(),
        fillColor: AppStyle.liteColors.cardColor,
      ),
      controller: _searchController,
      focusNode: _searchFocus,
    );
  }

  Future<void> _selectCity(final City city) async
  {
    await Global.favoriteCity.setCity(city);
    Routing.goBack(context, city);
  }

  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;

  List<City> _cities = [];
  List<RegExp> _filterWords = [];
  String? _filter;
}