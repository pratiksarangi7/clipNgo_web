import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

final cloud = FirebaseFirestore.instance;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // this key is used to manage the state of a form:
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const textFormFieldStyle = TextStyle(fontSize: 22);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 120),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text("Register yourself"),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              style: textFormFieldStyle,
              decoration: const InputDecoration(
                hintText: 'Enter your salon\'s name',
              ),
            ),
            // Mobile Number
            TextFormField(
              controller: _phoneNumberController,
              style: textFormFieldStyle,
              decoration: const InputDecoration(
                hintText: 'Enter your official mobile number',
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
              controller: _emailController,
              style: textFormFieldStyle,
              decoration: const InputDecoration(
                hintText: 'Enter a valid email address',
              ),
              // validator: (value) {
              //   if (value == null) return "Field can't be empty";
              //   if (!RegExp(r'@').hasMatch(value))
              //     return "Enter a valid email address";
              //   return null; // Return null if input is valid
              // },
            ),
            // Salon Address
            TextFormField(
              style: textFormFieldStyle,
              decoration: const InputDecoration(
                hintText: 'Enter your salon\'s address',
              ),
              validator: (value) {
                // Perform your validation logic here
                return null; // Return null if input is valid
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.location_on),
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                      onLocationSelected: (LatLng location) {
                        setState(() {
                          _selectedLocation = location;
                        });

                },
                icon: const Icon(Icons.location_on),
                label: const Text("Pick your location"))
          ],
        ),
      ),
    );
  }
}
