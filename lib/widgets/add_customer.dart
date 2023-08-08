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

  @override
  void dispose() {
    _textFieldController1.dispose();
    _textFieldController2.dispose();
    _textFieldController3.dispose();
    _textFieldController4.dispose();
    super.dispose();
  }

  void _saveData() {
    // Retrieve the entered data from the text fields
    String customerName = _textFieldController1.text;
    String phNo = _textFieldController2.text;
    String stylistName = _textFieldController3.text;
    String serviceCharge = _textFieldController4.text;
    var newCustomer = Customer(
        name: customerName,
        phoneNumber: phNo,
        assignedStylist: stylistName,
        serviceCharge: serviceCharge);
    setState(() {
      customers.add(newCustomer);
    });
    // Close the dialog
    Navigator.of(context).pop();
    _textFieldController1.clear();
    _textFieldController2.clear();
    _textFieldController3.clear();
    _textFieldController4.clear();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Data'),
          content: Column(
            children: [
              TextField(
                controller: _textFieldController1,
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              TextField(
                controller: _textFieldController2,
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
              TextField(
                controller: _textFieldController3,
                decoration: InputDecoration(labelText: 'Field 3'),
              ),
              TextField(
                controller: _textFieldController4,
                decoration: InputDecoration(labelText: 'Field 4'),
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
