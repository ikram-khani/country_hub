import 'package:country_hub/models/country_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CountryDataProvider with ChangeNotifier {
  final CountryData _countryData = CountryData();

  CountryData get countryData => _countryData;

  Dio dio = Dio();

  Future<void> fetchCountryData(String countryName) async {
    Response response =
        await dio.get('https://restcountries.com/v3.1/name/$countryName');

    if (response.statusCode == 200) {
      Map<String, dynamic> countryData = response.data[0];

      _countryData.name = countryData['name']['official'];

      // Check if 'capital' is a list and take the first element
      if (countryData['capital'] is List) {
        _countryData.capital = countryData['capital'][0];
      } else {
        _countryData.capital = countryData['capital'];
      }
      _countryData.population = countryData['population'].toString();

      _countryData.continent = countryData['continents'].join(", ");

      _countryData.flagUrl = countryData['flags']['png'];

      _countryData.languages = countryData['languages'].values.join(", ");
    } else {
      return;
    }
    notifyListeners();
  }
}
