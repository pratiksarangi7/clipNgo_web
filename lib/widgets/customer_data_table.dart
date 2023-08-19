import 'package:clipngo_web/data/customer_data.dart';
import 'package:clipngo_web/widgets/add_customer.dart';
import 'package:flutter/material.dart';

class CustomerDataTable extends StatefulWidget {
  const CustomerDataTable({super.key});

  @override
  State<CustomerDataTable> createState() => _CustomerDataTableState();
}

class _CustomerDataTableState extends State<CustomerDataTable> {
  bool _inMouseRegion = false;

  @override
  Widget build(BuildContext context) {
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
          borderRadius: BorderRadius.circular(10), // Set the border radius
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: const AddCustomer(),
                ),
              ],
            ),
            DataTable(
              columnSpacing: 150,
              columns: const [
                DataColumn(
                    label: Text(
                  'Customer',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                )),
                DataColumn(
                  label: Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Opted services',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Service Charge',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                )),
                DataColumn(label: Text('Actions')),
              ],
              rows: List.generate(customers.length, (index) {
                return DataRow(
                  cells: [
                    DataCell(Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          customers[index].name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          customers[index].assignedStylist,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        )
                      ],
                    )),
                    DataCell(Text(customers[index].phoneNumber)),
                    DataCell(Text(customers[index].optedServices)),
                    DataCell(Text(
                      "       ₹${customers[index].serviceCharge}",
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Handle edit action
                            // You can implement the logic to edit customer data here
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Handle delete action
                            setState(() {
                              customers.removeAt(index);
                            });
                          },
                        ),
                      ],
                    )),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
