import 'package:flutter/material.dart';
import 'pages/solar_profit_calculator_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SolarProfitCalculatorPage(),
    );
  }
}
