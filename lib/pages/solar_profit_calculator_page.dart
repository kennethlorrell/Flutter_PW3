import 'package:flutter/material.dart';
import '../services/calculations.dart';
import '../models/solar_profit.dart';
import '../utils/helpers.dart';

class SolarProfitCalculatorPage extends StatefulWidget {
  @override
  _SolarProfitCalculatorPageState createState() => _SolarProfitCalculatorPageState();
}

class _SolarProfitCalculatorPageState extends State<SolarProfitCalculatorPage> {
  final TextEditingController dailyAveragePowerController = TextEditingController(text: "5");
  final TextEditingController actualDeviationController = TextEditingController(text: "1");
  final TextEditingController desiredDeviationController = TextEditingController(text: "0.25");
  final TextEditingController electricityCostController = TextEditingController(text: "7");

  SolarProfit? result;

  void _calculateProfit() {
    final double dailyPower = double.tryParse(dailyAveragePowerController.text) ?? 0.0;
    final double actualDev = double.tryParse(actualDeviationController.text) ?? 0.0;
    final double desiredDev = double.tryParse(desiredDeviationController.text) ?? 0.0;
    final double cost = double.tryParse(electricityCostController.text) ?? 0.0;

    setState(() {
      result = calculateSolarProfit(dailyPower, actualDev, desiredDev, cost);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор розрахунку прибутку від сонячних станцій'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Введіть параметри для розрахунку прибутку:"),
            SizedBox(height: 8),
            TextField(
              controller: dailyAveragePowerController,
              decoration: InputDecoration(
                labelText: "Середньодобова потужність (МВт)",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            TextField(
              controller: actualDeviationController,
              decoration: InputDecoration(
                labelText: "Фактичне відхилення (МВт)",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            TextField(
              controller: desiredDeviationController,
              decoration: InputDecoration(
                labelText: "Бажане відхилення (МВт)",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            TextField(
              controller: electricityCostController,
              decoration: InputDecoration(
                labelText: "Вартість електроенергії (грн / кВт·год)",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateProfit,
              child: Text("Розрахувати прибуток"),
            ),
            SizedBox(height: 16),
            if (result != null) ...[
              Text("Прибуток до удосконалення: ${result!.netProfitWithActualDeviation.roundTo(1)} тис. грн"),
              Text("Прибуток після удосконалення: ${result!.netProfitWithDesiredDeviation.roundTo(1)} тис. грн"),
            ],
          ],
        ),
      ),
    );
  }
}
