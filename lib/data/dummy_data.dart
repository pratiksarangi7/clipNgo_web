import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

Random random = Random();

final List<FlSpot> dummyData1 = List.generate(12, (index) {
  double randomY = 50000 + random.nextDouble() * (500000 - 50000);
  return FlSpot(
    index.toDouble(),
    randomY,
  );
});

// Generate dummyData2 with random values
final List<FlSpot> dummyData2 = List.generate(12, (index) {
  double randomY = 50000 + random.nextDouble() * (500000 - 50000);
  return FlSpot(index.toDouble(), randomY);
});

// Generate dummyData3 with random values
final List<FlSpot> dummyData3 = List.generate(12, (index) {
  double randomY = 50000 + random.nextDouble() * (500000 - 50000);
  return FlSpot(index.toDouble(), randomY);
});
final List<String> monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
final List<String> yAxisLabels = [
  "50,000",
  "100,000",
  "150,000",
  "200,000",
  "250,000",
  "300,000",
  "350,000",
  "400,000",
  "450,000",
  "500,000",
  "550,000",
  "600,000"
];
