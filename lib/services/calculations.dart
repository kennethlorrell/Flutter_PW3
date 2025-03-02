import 'dart:math';
import '../models/solar_profit.dart';

// Обчислюємо чистий прибуток з фактичним і бажаним відхиленням
SolarProfit calculateSolarProfit(
    double dailyPower,
    double actualDeviation,
    double desiredDeviation,
    double electricityCost,
    ) {
  double netProfitActual = calculateNetProfit(dailyPower, actualDeviation, electricityCost);
  double netProfitDesired = calculateNetProfit(dailyPower, desiredDeviation, electricityCost);

  return SolarProfit(
    netProfitWithActualDeviation: netProfitActual,
    netProfitWithDesiredDeviation: netProfitDesired,
  );
}

// Обчислюємо чистий прибуток з відхиленням
double calculateNetProfit(
    double dailyPower,
    double deviation,
    double electricityCost,
    ) {
  // Отримуємо нижню та верхню границі допустимого відхилення
  List<double> bounds = calculateBounds(dailyPower);
  double lowerBound = bounds[0];
  double upperBound = bounds[1];

  double energyDistribution = calculateEnergyDistribution(lowerBound, upperBound, dailyPower, deviation);
  double energyWithoutImbalance = dailyPower * 24 * energyDistribution;
  double profit = energyWithoutImbalance * electricityCost;

  double energyWithImbalance = (dailyPower * 24) - energyWithoutImbalance;
  double penalty = energyWithImbalance * electricityCost;

  return profit - penalty;
}

// Вираховуємо нижню та верхню границі допустимого відхилення
List<double> calculateBounds(double dailyPower) {
  double lowerBound = dailyPower * (1 - 0.05);
  double upperBound = dailyPower * (1 + 0.05);
  return [lowerBound, upperBound];
}

// Інтегруємо значення у межах допустимих границь
double calculateEnergyDistribution(
    double lowerBound,
    double upperBound,
    double mean,
    double standardDeviation,
    ) {
  double step = 0.001;
  double result = 0.0;
  double x = lowerBound;

  while (x < upperBound) {
    double y1 = normalDistribution(x, mean, standardDeviation);
    double y2 = normalDistribution(x + step, mean, standardDeviation);

    result += (y1 + y2) * step / 2;
    x += step;
  }

  return result;
}

// Рахуємо значення нормального розподілу у певній точці
double normalDistribution(
    double x,
    double mean,
    double standardDeviation,
    ) {
  return (1 / (standardDeviation * sqrt(2 * pi))) *
      exp(-((x - mean) * (x - mean)) / (2 * standardDeviation * standardDeviation));
}
