import 'package:clipngo_web/data/dummy_data.dart';
import 'package:clipngo_web/data/titles_data.dart';
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
    return Row(
      children: [
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
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 6,
                  gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: Colors.grey.withOpacity(0.4),
                            strokeWidth: 0.8);
                      },
                      getDrawingVerticalLine: (value) {
                        return const FlLine(color: Colors.white);
                      }),
                  borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                        bottom: BorderSide(width: 1),
                        left: BorderSide(width: 1),
                      )),
                  titlesData: LineTitles.getTitlesData(),
                  lineBarsData: [
                    // The red line
                    LineChartBarData(
                      spots: dummyData1,
                      dotData: const FlDotData(show: false),
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.indigo,
                    ),
                    // The orange line
                    LineChartBarData(
                      dotData: const FlDotData(show: false),
                      spots: dummyData2,
                      isCurved: true,
                      barWidth: 2,
                      color: const Color.fromARGB(255, 54, 209, 244),
                    ),
                  ],
                ),
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
                borderRadius:
                    BorderRadius.circular(10), // Set the border radius
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
      ],
    );
  }
}
