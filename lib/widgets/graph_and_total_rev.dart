import 'package:clipngo_web/providers/salon_id_provider.dart';
import 'package:clipngo_web/widgets/total_rev_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var bottomNames = ["today's", "last 7 days", " last 30 days"];
final valuesProvider = FutureProvider<List<int>>((ref) async {
  final documentId = ref.read(idProvider);
  final snapshot = await FirebaseFirestore.instance
      .collection('email-salons')
      .doc(documentId)
      .get();
  final monthlyIncome = snapshot.get('monthlyIncome') as int;
  final todayIncome = snapshot.get('todayIncome') as int;
  final weekIncome = snapshot.get('weekIncome') as int;
  return [monthlyIncome, todayIncome, weekIncome];
});
final incomeProvider = FutureProvider.autoDispose<List<int>>((ref) async {
  final documentId = ref.read(idProvider);
  final snapshot = await FirebaseFirestore.instance
      .collection('email-salons')
      .doc(documentId)
      .get();
  final incomeList = snapshot.get('monthsIncome') as List<dynamic>;
  return incomeList.cast<int>();
});

class GraphAndTotalRevenue extends StatefulWidget {
  const GraphAndTotalRevenue({super.key});

  @override
  State<GraphAndTotalRevenue> createState() => _GraphAndTotalRevenueState();
}

class _GraphAndTotalRevenueState extends State<GraphAndTotalRevenue> {
  bool _inGraphRegion = false;
  bool _inRevenueRegion = false;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 3,
        child: MouseRegion(
          onEnter: (event) => setState(() {
            _inGraphRegion = true;
          }),
          onExit: (event) => setState(() {
            _inGraphRegion = false;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(10), // Set the border radius
                boxShadow: _inGraphRegion
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9), // Shadow color
                          spreadRadius: 5, // How far the shadow spreads
                          blurRadius: 10, // How blurry the shadow is
                          offset: const Offset(0, 3), // Offset of the shadow
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow color
                          spreadRadius: 5, // How far the shadow spreads
                          blurRadius: 10, // How blurry the shadow is
                          offset: const Offset(0, 3), // Offset of the shadow
                        ),
                      ]),
            height: 350,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Revenue Graph',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final incomeList = ref.watch(incomeProvider);
                      if (incomeList.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (incomeList.hasError) {
                        return Text('Error: ${incomeList.error}');
                      }
                      final data = incomeList.asData!.value;
                      return LineChart(
                        LineChartData(
                          borderData: FlBorderData(
                              border: const Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            left: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          )),
                          gridData: const FlGridData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.9),
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                              dotData: const FlDotData(show: false),
                              spots: [
                                for (int i = 0; i < data.length; i++)
                                  FlSpot(i.toDouble(), data[i].toDouble()),
                              ],
                              isCurved: true,
                              color: Theme.of(context).colorScheme.primary,
                              barWidth: 2,
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, titleMeta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text('Jan');
                                    case 1:
                                      return const Text('Feb');
                                    case 2:
                                      return const Text('Mar');
                                    case 3:
                                      return const Text('Apr');
                                    case 4:
                                      return const Text('May');
                                    case 5:
                                      return const Text('Jun');
                                    case 6:
                                      return const Text('JUl');
                                    case 7:
                                      return const Text('Aug');
                                    case 8:
                                      return const Text('Sept');
                                    case 9:
                                      return Text('Oct');
                                    default:
                                      return const Text('');
                                  }
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                getTitlesWidget: (value, titleMeta) {
                                  return Text('\$${value.toInt()}');
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 30,
      ),
      Expanded(
        flex: 1, // This element is twice the size of the previous one
        child: MouseRegion(
          onEnter: (event) => setState(() {
            _inRevenueRegion = true;
          }),
          onExit: (event) => setState(() {
            _inRevenueRegion = false;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10), // Set the border radius
              boxShadow: _inRevenueRegion
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.9), // Shadow color
                        spreadRadius: 5, // How far the shadow spreads
                        blurRadius: 10, // How blurry the shadow is
                        offset: const Offset(0, 3), // Offset of the shadow
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // Shadow color
                        spreadRadius: 5, // How far the shadow spreads
                        blurRadius: 10, // How blurry the shadow is
                        offset: const Offset(0, 3), // Offset of the shadow
                      ),
                    ],
            ),
            height: 350,
            padding: const EdgeInsets.all(20),
            child: Consumer(builder: (context, ref, _) {
              final values =
                  ref.watch(valuesProvider).asData?.value ?? [0, 0, 0];
              values.sort();
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 22, bottom: 10, left: 30),
                          child: Text(
                            "Total Revenue",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < 3; i++)
                      RevenueCard(
                        revData: values[i],
                        text: bottomNames[i],
                      )
                  ]);
            }),
          ),
        ),
      ),
    ]);
  }
}
