import 'package:clipngo_web/widgets/customer_data_table.dart';
import 'package:clipngo_web/widgets/graph_and_total_rev.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        GraphAndTotalRevenue(),
        SizedBox(
          height: 25,
        ),
        CustomerDataTable()
      ],
    );
  }
}
