import 'package:clipngo_web/data/customer_data.dart';
import 'package:clipngo_web/providers/salon_id_provider.dart';
import 'package:clipngo_web/providers/selected_stylist_provider.dart';
import 'package:clipngo_web/widgets/select_stylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clipngo_web/widgets/opted_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clipngo_web/providers/selected_services_provider.dart';
import 'package:clipngo_web/providers/total_cost_provider.dart';

class AddCustomer extends ConsumerStatefulWidget {
  const AddCustomer({super.key});
  @override
  ConsumerState<AddCustomer> createState() {
    return _AddCustomerState();
  }
}

class _AddCustomerState extends ConsumerState<AddCustomer> {
  final _textFieldController1 = TextEditingController();
  final _textFieldController2 = TextEditingController();
  final _textFieldController3 = TextEditingController();
  bool isSaving = false;

  @override
  void dispose() {
    _textFieldController1.dispose();
    _textFieldController2.dispose();
    _textFieldController3.dispose();
    super.dispose();
  }

  final uniqueIDProvider = FutureProvider.autoDispose<String>((ref) async {
    final documentId = ref.read(idProvider);
    final snapshot = await FirebaseFirestore.instance
        .collection('email-salons')
        .doc(documentId)
        .get();
    return snapshot.id;
  });
  Future<void> _saveData() async {
    String customerName = _textFieldController1.text;
    String phNo = _textFieldController2.text;
    double discountAmount = double.tryParse(_textFieldController3.text) ?? 0.0;
    String stylistName = ref.read(stylistProvider);
    final optedServicesList = ref.read(selectedServicesProvider);
    final totalCost = ref.read(totalCostProvider);
    // String optedServices = optedServices0;
    String serviceCharge = (totalCost - discountAmount).toString();

    final snapshot = await FirebaseFirestore.instance
        .collection('email-salons')
        .doc(ref.read(idProvider))
        .get();

    final salonName = snapshot.data()!['salon-name'] as String;
    String optedServices0 = "";
    for (final service in optedServicesList) {
      optedServices0 += "$service\n";
    }
    // Retrieve the entered data from the text fields

    final snapshotPhoneUid = await FirebaseFirestore.instance
        .collection('phone-uid')
        .doc(phNo)
        .get();
    final userId = snapshotPhoneUid[phNo] as String;
    // var newCustomer = Customer(
    //   name: customerName,
    //   phoneNumber: phNo,
    //   assignedStylist: stylistName,
    //   optedServices: optedServices,
    //   serviceCharge: serviceCharge,
    // );

    final uniqueID = await ref.read(uniqueIDProvider.future);

    final docRef =
        FirebaseFirestore.instance.collection('current-bookings').doc(uniqueID);

    final docSnapshot = await docRef.get();

    final customerList =
        docSnapshot.exists ? docSnapshot.data()![uniqueID] ?? [] : [];

    customerList.add({
      "date-time": DateTime.now(),
      'price': totalCost,
      'user-id': userId,
      'salon-id': uniqueID,
      'services': optedServicesList,
      'status': 'pending',
      'salon-name': salonName,
    });

    await docRef.set({
      uniqueID: customerList,
    }, SetOptions(merge: true));

    // Close the dialog
    Navigator.of(context).pop();
    _textFieldController1.clear();
    _textFieldController2.clear();
    _textFieldController3.clear();

    optedServicesList.clear();
    ref.invalidate(totalCostProvider);
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Customer details'),
          content: SizedBox(
            width: 500,
            height: 600,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textFieldController1,
                        decoration: const InputDecoration(
                          labelText: 'Customer name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textFieldController2,
                        decoration: const InputDecoration(
                          labelText: 'Phone number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // insert select_stylist widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectStylist(),
                    const OptedServices(),
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
                TextField(
                  controller: _textFieldController3,
                  decoration:
                      const InputDecoration(labelText: 'Discount Amount'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {
                  isSaving = true;
                });
                await _saveData();
                setState(() {
                  isSaving = false;
                });
              },
              child: isSaving
                  ? const CircularProgressIndicator()
                  : const Text('save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: _showDialog,
        icon: const Icon(Icons.add),
        label: const Text("Add"));
  }
}
