import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  final documentId = "salon1@clipngo.com";

  @override
  Widget build(BuildContext context) {
    print("building profile screen");
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
        String name = documentData['name'];
        String phoneNumber = documentData['number'];
        String emailId = documentData['email'];
        String address = documentData['address'];
        String image = documentData['image'];

        return Column(
          children: [
            Text('Name: $name'),
            Text('Phone Number: $phoneNumber'),
            Text('Email ID: $emailId'),
            Text('Address: $address'),
            HtmlWidget(
                "<img src=$image alt=\"Description of the image\">"), // Display the image using its URL
          ],
        );
      },
    );
  }
}
