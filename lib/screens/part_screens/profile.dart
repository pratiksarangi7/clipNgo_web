import 'dart:typed_data';
import 'package:clipngo_web/providers/salon_id_provider.dart';
import 'package:clipngo_web/widgets/services_checkbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Uint8List? _bytesData;
  String _fileName = '';

  startWebFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) {
        setState(() {
          _bytesData = const Base64Decoder()
              .convert(reader.result.toString().split(",").last);
          _fileName =
              'salon-image-${DateTime.now().millisecondsSinceEpoch}.jpg';
        });
      });
      reader.readAsDataUrl(file);
    });
  }

  uploadFile() async {
    if (_bytesData == null) {
      return;
    }
    // final metadata = SettableMetadata(
    //   contentDisposition: 'inline',
    // );
    final storageRef =
        FirebaseStorage.instance.ref().child('salon-images/$_fileName');
    final uploadTask = storageRef.putData(
      _bytesData!,
    );
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    final documentId = ref.read(idProvider);
    final salonDocRef =
        FirebaseFirestore.instance.collection('email-salons').doc(documentId);
    await salonDocRef.update({'image': downloadUrl});
  }

  @override
  Widget build(BuildContext context) {
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
        String name = documentData['name'];
        // String phoneNumber = documentData['number'];
        String emailId = documentData['email'];
        String address = documentData['address'];
        String image = documentData['image'];
        return Column(
          children: [
            Text('Name: $name'),
            // Text('Phone Number: $phoneNumber'),
            Text('Email ID: $emailId'),
            Text('Address: $address'),
            if (image == 'null')
              Column(
                children: [
                  const Text('Let\'s upload Image'),
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.pink,
                    elevation: 8,
                    highlightElevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textColor: Colors.white,
                    child: const Text("Select Photo"),
                    onPressed: () {
                      startWebFilePicker();
                    },
                  ),
                  const Divider(
                    color: Colors.teal,
                  ),
                  _bytesData != null
                      ? Image.memory(_bytesData!, width: 400, height: 400)
                      : Container(),
                  ElevatedButton(
                    onPressed: () async {
                      await uploadFile();
                    },
                    child: const Text('Upload Photo'),
                  ),
                ],
              )
            else
              SizedBox(
                height: 400,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: HtmlWidget("<img src=$image>"),
                ),
              ),
            const ServiceList()
          ],
        );
      },
    );
  }
}
