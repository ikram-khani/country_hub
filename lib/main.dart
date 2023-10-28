import 'package:country_hub/view/screens/home.dart';
import 'package:country_hub/providers/country_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => CountryDataProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Country Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 140, 223, 61),
          secondary: const Color.fromARGB(255, 228, 233, 213),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
