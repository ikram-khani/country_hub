import 'package:country_hub/providers/country_data_provider.dart';
import 'package:country_hub/view/widgets/text_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode _node = FocusNode();

  String _countryOfficialName = '';
  String _countryCapital = '';
  String _countryContinent = '';
  String _countryLanguages = '';
  String _countryPopulation = '';
  String _countryFlagUrl = '';

  var _isLoaded = false;

  final _formFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _getCountryData('Pakistan');
  }

  Future<void> _searchCountry() async {
    setState(() {
      _isLoaded = false;
    });
    bool isValid = _formFieldKey.currentState!.validate();

    if (isValid) {
      _formFieldKey.currentState!.save();
      _node.unfocus();
    }
    if (!isValid) {
      setState(() {
        _isLoaded = true;
      });
    }
  }

  Dio dio = Dio();
  Future<void> _getCountryData(String countryName) async {
    final countryProvider =
        Provider.of<CountryDataProvider>(context, listen: false);
    final countryDataProvider =
        Provider.of<CountryDataProvider>(context, listen: false).countryData;
    try {
      await countryProvider.fetchCountryData(countryName);
    } on DioException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message.toString(),
          ),
        ),
      );
      setState(() {
        _isLoaded = true;
      });
      return;
    }
    setState(() {
      _countryOfficialName = countryDataProvider.name!;
      _countryCapital = countryDataProvider.capital!;
      _countryPopulation = countryDataProvider.population!;
      _countryFlagUrl = countryDataProvider.flagUrl!;
      _countryContinent = countryDataProvider.continent!;
      _countryLanguages = countryDataProvider.languages!;

      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(
          'Country Hub',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                width: screenSize.width * 0.75,
                child: TextFormField(
                  focusNode: _node,
                  key: _formFieldKey,
                  keyboardType: TextInputType.name,
                  enableSuggestions: true,
                  autocorrect: true,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _searchCountry();
                      },
                    ),
                    hintText: 'Pakistan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Search',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter a country name";
                    }
                    if (!value.contains(
                      RegExp(r'^[A-Za-z\s-]+$', caseSensitive: false),
                    )) {
                      return 'Please enter a valid country name';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    //done this check cz in restcountries api 'cn' is used for china (the word china give some null error that's why use 'cn' if someone enter china)
                    if (newValue!.trim().toLowerCase() == 'china') {
                      _getCountryData('cn');
                      return;
                    }
                    _getCountryData(newValue.trim());
                  },
                  onFieldSubmitted: (value) => _searchCountry(),
                ),
              ),
            ),
            _isLoaded
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            color: Theme.of(context).colorScheme.secondary,
                            width: screenSize.width * 0.75,
                            height: screenSize.height * 0.2,
                            child: Image(
                              image: NetworkImage(
                                _countryFlagUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextCard(
                              titleText: 'Country',
                              valueText: _countryOfficialName),
                          const SizedBox(height: 20),
                          TextCard(
                              titleText: 'Capital', valueText: _countryCapital),
                          const SizedBox(height: 20),
                          TextCard(
                              titleText: 'Population',
                              valueText: _countryPopulation),
                          const SizedBox(height: 20),
                          TextCard(
                              titleText: 'Languages',
                              valueText: _countryLanguages),
                          const SizedBox(height: 20),
                          TextCard(
                              titleText: 'Continent',
                              valueText: _countryContinent),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
