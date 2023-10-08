import 'package:clipngo_web/data/customer_data.dart';
import 'package:clipngo_web/providers/salon_id_provider.dart';
import 'package:clipngo_web/widgets/add_customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomerDataTable extends ConsumerStatefulWidget {
  const CustomerDataTable({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerDataTable> createState() => _CustomerDataTableState();
}

final uniqueIDProvider = FutureProvider.autoDispose<String>((ref) async {
  final documentId = ref.read(idProvider);
  final snapshot = await FirebaseFirestore.instance
      .collection('email-salons')
      .doc(documentId)
      .get();
  return snapshot.id;
});

class _CustomerDataTableState extends ConsumerState<CustomerDataTable> {
  bool _inMouseRegion = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('current-bookings')
          .doc(ref.read(idProvider))
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final bookingIdList =
              List<Map<String, dynamic>>.from(data['booking-id'] ?? []);
          print("bookingIDList: $bookingIdList");
          final customers = bookingIdList;

          return MouseRegion(
            onEnter: (_) {
              setState(() {
                _inMouseRegion = true;
              });
            },
            onExit: (_) {
              setState(() {
                _inMouseRegion = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(10), // Set the border radius
                boxShadow: _inMouseRegion
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
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 20),
                        child: Text("Current customers",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 18)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: AddCustomer(),
                      ),
                    ],
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(4),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(2),
                    },
                    children: [
                      const TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              'User ID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TableCell(
                            child: Text(
                              'Date Time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TableCell(
                            child: Text(
                              'Salon ID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TableCell(
                            child: Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TableCell(
                            child: Text(
                              'Price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TableCell(
                            child: Text(
                              'Services',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      for (final booking in customers)
                        TableRow(
                          children: [
                            TableCell(
                              child: FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('phone-uid')
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final documents = snapshot.data!.docs;

                                    final matchingDocument =
                                        documents.firstWhere((document) {
                                      return document.id == booking['user-id'];
                                    });
                                    if (matchingDocument.exists) {
                                      final phoneNumber =
                                          matchingDocument[matchingDocument.id];
                                      return Text(phoneNumber);
                                    } else {
                                      return const Text(
                                          'Phone number not found');
                                    }
                                  } else {
                                    return const Text('Loading...');
                                  }
                                },
                              ),
                            ),
                            TableCell(
                              child: Text(
                                DateFormat('EEE, MMM d, h:mm a')
                                    .format(booking['date-time'].toDate()),
                              ),
                            ),
                            TableCell(child: Text(booking['salon-id'])),
                            TableCell(child: Text(booking['status'])),
                            TableCell(child: Text('₹${booking['price']}')),
                            TableCell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (final service in booking['services'])
                                    if (service['selected'])
                                      Text(
                                          '${service['name']} - ₹${service['price']}'),
                                ],
                              ),
                            ),
                          ],
                        )
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
