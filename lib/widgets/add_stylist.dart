import 'package:clipngo_web/providers/salon_id_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStylist extends ConsumerStatefulWidget {
  const AddStylist({Key? key}) : super(key: key);

  @override
  _AddStylistState createState() => _AddStylistState();
}

class _AddStylistState extends ConsumerState<AddStylist> {
  final _stylistControllers = <TextEditingController>[];
  final _stylists = <String>[];

  void _addStylist() {
    setState(() {
      _stylistControllers.add(TextEditingController());
    });
  }

  Future<void> _saveStylists() async {
    final collectionRef = FirebaseFirestore.instance.collection('email-salons');
    final providerDocRef = collectionRef.doc(ref.read(idProvider));
    final stylistsList =
        _stylistControllers.map((controller) => controller.text).toList();
    await providerDocRef
        .set({'stylists': stylistsList}, SetOptions(merge: true));
    setState(() {
      _stylistControllers.clear();
      _stylists.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._stylistControllers.map((controller) {
          final index = _stylistControllers.indexOf(controller);
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Stylist name',
                  ),
                  onChanged: (value) {
                    _stylists[index] = value;
                  },
                ),
              ),
            ],
          );
        }),
        IconButton(
          onPressed: _addStylist,
          icon: const Icon(Icons.add),
        ),
        ElevatedButton(
          onPressed: _saveStylists,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
