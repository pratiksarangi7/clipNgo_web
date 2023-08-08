import 'package:clipngo_web/data/dash_board_data.dart';
import 'package:clipngo_web/providers/page_data_provider.dart';
import 'package:clipngo_web/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:clipngo_web/screens/part_screens/dash_board.dart';
import 'package:clipngo_web/screens/part_screens/employee_details.dart';
import 'package:clipngo_web/screens/part_screens/profile.dart';
import 'package:clipngo_web/screens/part_screens/transaction_hist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget onClicked(int index) {
  switch (index) {
    case 1:
      return const ProfileScreen();
    case 2:
      return const EmpDetailsScreen();
    case 3:
      return const TransHistoryScreen();
    default:
      return const DashBoardScreen();
  }
}

class AppMenu extends ConsumerWidget {
  const AppMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              height: 26,
              width: 26,
              //child: Image.asset('lib/assets/images/clipNgoLogo.png'),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "ClipN'Go",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ]),
        ),
        for (int i = 0; i < 4; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: MenuCard(
              content: menuDetails[i],
              contentIcon: iconDetails[i],
              onClicked: () {
                ref.read(partScreenIndexProvider.notifier).state = i;
              },
              itemIndex: i,
            ),
          )
      ],
    );
  }
}
