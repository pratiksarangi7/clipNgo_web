import 'dart:typed_data';
import 'package:clipngo_web/providers/salon_id_provider.dart';
import 'package:clipngo_web/widgets/add_stylist.dart';
import 'package:clipngo_web/widgets/services_checkbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Uint8List? _bytesData;
  String _fileName = '';
  final _capacityController = TextEditingController();

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

  void _saveCapacity() {
    final documentId = ref.read(idProvider);
    final capacity = _capacityController.text;
    FirebaseFirestore.instance
        .collection('email-salons')
        .doc(documentId)
        .update({'capacity': capacity})
        .then((value) => print("Capacity saved"))
        .catchError((error) => print("Failed to save capacity: $error"));
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
        String? image = documentData['image'];
        String? capacity = documentData['capacity'];
        List<dynamic>? stylists = documentData['stylists'];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Name: $name',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 22),
                    ),
                  ),
                  // Text('Phone Number: $phoneNumber'),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Email ID: $emailId',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Address: $address',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Services: ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 19),
                    ),
                  ),
                  const ServiceList(),
                ],
              ),
              SizedBox(
                width: 270,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Stylists: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 19),
                      ),
                    ),
                    if (stylists != null)
                      for (var stylist in stylists)
                        Text(
                          stylist.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 19),
                        ),
                    if (stylists == null) const AddStylist(),
                    if (capacity == null)
                      Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 80,
                            child: TextField(
                              controller: _capacityController,
                              decoration: const InputDecoration(
                                labelText: 'Capacity',
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _saveCapacity,
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    if (capacity != null)
                      Text(
                        'Capacity: $capacity',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 19),
                      ),
                  ],
                ),
              ),
              if (image == null)
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
                  width: 200,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: HtmlWidget("<img src=$image>"),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
