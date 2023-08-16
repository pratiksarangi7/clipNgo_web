import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // this key is used to manage the state of a form:
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 120),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text("Register yourself"),
            const SizedBox(height: 20),
            // Mobile Number
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                hintText: 'Enter your mobile number',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid mobile number';
                }

                // Remove non-digit characters and check if the remaining length is 10
                String sanitizedValue = value.replaceAll(RegExp(r'\D'), '');
                if (sanitizedValue.length != 10) {
                  return 'Mobile number should contain exactly 10 digits';
                }
                return null; // Return null if input is valid
              },
            ),
            // Valid Email Address
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Valid Email Address',
                hintText: 'Enter a valid email address',
              ),
              validator: (value) {
                // Perform your validation logic here
                return null; // Return null if input is valid
              },
            ),
            // Salon Address
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Salon Address',
                hintText: 'Enter the salon address',
              ),
              validator: (value) {
                // Perform your validation logic here
                return null; // Return null if input is valid
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Form is valid, perform submission logic here
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
