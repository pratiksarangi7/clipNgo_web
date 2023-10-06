import 'package:clipngo_web/providers/selected_services_provider.dart';
import 'package:flutter/material.dart';
import 'package:clipngo_web/widgets/check_box_element.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clipngo_web/providers/salon_id_provider.dart';

class OptedServices extends ConsumerStatefulWidget {
  const OptedServices({
    super.key,
  });

  @override
  ConsumerState<OptedServices> createState() => _OptedServicesState();
}

class _OptedServicesState extends ConsumerState<OptedServices> {
  late List<String> services;
  late Map<String, double> serviceCharges;
  late final Map<String, bool> _isSelected = {};

  @override
  void initState() {
    super.initState();
    services = ["Select Services"];
    serviceCharges = {"Select Services": 0};
    _isSelected["Select Services"] = false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('email-salons')
          .doc(ref.read(idProvider))
          .collection('services')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No services found');
        }
        // Services data is available here
        final servicesData = snapshot.data!.docs;
        print(servicesData);
        services = ["Select Services"];
        serviceCharges = {"Select Services": 0};
        _isSelected["Select Services"] = false;
        for (var serviceData in servicesData) {
          final serviceName = serviceData['name'];
          final servicePrice = serviceData['price'];
          services.add(serviceName);
          serviceCharges[serviceName] = servicePrice;
          _isSelected[serviceName] = false;
        }
        // final selectedServices = ref.read(selectedServicesProvider);
        return DropdownButton(
          value: services[0],
          items: services.map((service) {
            return DropdownMenuItem(
              enabled: false,
              value: service,
              child: Expanded(
                child: service != "Select Services"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$service (₹${serviceCharges[service]})"),
                          CheckBoxElement(
                            currentService: service,
                            onSelected: _isSelected,
                            serviceCharges: serviceCharges,
                          ),
                        ],
                      )
                    : Text(service),
              ),
            );
          }).toList(),
          onChanged: (_) {},
        );
      },
    );
  }
}
