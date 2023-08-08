import 'package:clipngo_web/data/customer_data.dart';
import 'package:flutter/material.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});
  @override
  State<AddCustomer> createState() {
    return _AddCustomerState();
  }
}

class _AddCustomerState extends State<AddCustomer> {
  final _textFieldController1 = TextEditingController();
  final _textFieldController2 = TextEditingController();
  final _textFieldController3 = TextEditingController();
  final _textFieldController4 = TextEditingController();
  final _textFieldController5 = TextEditingController();

  @override
  void dispose() {
    _textFieldController1.dispose();
    _textFieldController2.dispose();
    _textFieldController3.dispose();
    _textFieldController4.dispose();
    _textFieldController5.dispose();
    super.dispose();
  }

  void _saveData() {
    // Retrieve the entered data from the text fields
    String customerName = _textFieldController1.text;
    String phNo = _textFieldController2.text;
    String stylistName = _textFieldController3.text;
    String optedServices = _textFieldController4.text;
    String serviceCharge = _textFieldController5.text;

    var newCustomer = Customer(
      name: customerName,
      phoneNumber: phNo,
      assignedStylist: stylistName,
      optedServices: optedServices,
      serviceCharge: serviceCharge,
    );
    setState(() {
      customers.add(newCustomer);
    });
    // Close the dialog
    Navigator.of(context).pop();
    _textFieldController1.clear();
    _textFieldController2.clear();
    _textFieldController3.clear();
    _textFieldController4.clear();
    _textFieldController5.clear();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Customer details'),
          content: Column(
            children: [
              TextField(
                controller: _textFieldController1,
                decoration: const InputDecoration(labelText: 'Customer name: '),
              ),
              TextField(
                controller: _textFieldController2,
                decoration: const InputDecoration(labelText: 'Phone number: '),
              ),
              TextField(
                controller: _textFieldController3,
                decoration: const InputDecoration(labelText: 'Field 3'),
              ),
              TextField(
                controller: _textFieldController4,
                decoration: const InputDecoration(labelText: 'Field 4'),
              ),
              TextField(
                controller: _textFieldController4,
                decoration: const InputDecoration(labelText: 'Field 4'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: _saveData,
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
