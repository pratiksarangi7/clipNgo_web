// split_view.dart
import 'package:clipngo_web/providers/page_data_provider.dart';
import 'package:clipngo_web/screens/part_screens/dash_board.dart';
import 'package:clipngo_web/screens/part_screens/employee_details.dart';
import 'package:clipngo_web/screens/part_screens/profile.dart';
import 'package:clipngo_web/screens/part_screens/transaction_hist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitView extends ConsumerWidget {
  const SplitView({
    Key? key,
    // menu takes the AppMenu() widget as argument when SplitView called
    required this.menu,
    this.breakpoint = 600,
    this.menuWidth = 240,
  }) : super(key: key);
  final Widget menu;
  final double breakpoint;
  final double menuWidth;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    // watch triggers build method when it sees a change in state.
    final content = onClicked(ref.watch(partScreenIndexProvider));
    if (screenWidth >= breakpoint) {
      // widescreen: menu on the left, content on the right
      return Scaffold(
        body: ListView(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: menu,
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      content,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      );
    } else {
      // narrow screen: show content, menu inside drawer
      return Scaffold(
        body: content,
        drawer: SizedBox(
          width: menuWidth,
          child: Drawer(
            child: menu,
          ),
        ),
      );
    }
  }
}
