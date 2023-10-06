import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clipngo_web/providers/selected_stylist_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clipngo_web/providers/salon_id_provider.dart';

class SelectStylist extends ConsumerWidget {
  SelectStylist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentId = ref.read(idProvider);
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('email-salons')
          .doc(documentId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Document not found');
        }
        // Document data is available here
        var documentData = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic>? stylists = documentData['stylists'];
        if (stylists == null) {
          stylists = ["Select Stylist"];
        } else {
          stylists.insert(0, "Select Stylist");
        }
        final selectedStylist = ref.watch(stylistProvider);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
            value: selectedStylist,
            items: stylists.map((stylist) {
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
      },
    );
  }
}
