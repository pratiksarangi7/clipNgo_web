import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clipngo_web/providers/selected_stylist_provider.dart';

class SelectStylist extends ConsumerWidget {
  SelectStylist({super.key});

  final List<String> dummyStylists = [
    "Select Stylist",
    "Bhavya",
    "Krishna",
    "Saksham"
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedStylist = ref.watch(stylistProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        value: _selectedStylist,
        items: dummyStylists.map((stylist) {
          return DropdownMenuItem(
            value: stylist,
            child: Text(stylist),
          );
        }).toList(),
        onChanged: (value) {
          ref.read(stylistProvider.notifier).state = value.toString();
        },
      ),
    );
  }
}
