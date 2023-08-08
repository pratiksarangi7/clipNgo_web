import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static getTitlesData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text("JAN");
                  case 1:
                    return const Text("FEB");
                  case 2:
                    return const Text("MAR");
                  case 3:
                    return const Text("APR");
                  case 4:
                    return const Text("MAY");
                  case 5:
                    return const Text("JUN");
                  case 6:
                    return const Text("JUL");
                  case 7:
                    return const Text("AUG");
                  case 8:
                    return const Text("SEP");
                  case 9:
                    return const Text("OCT");
                  case 10:
                    return const Text("NOV");
                  case 11:
                    return const Text("DEC");
                }
                return const Text("");
              }),
        ),
      );
}
