import 'package:clipngo_web/providers/salon_id_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Service {
  String name;
  bool selected;
  double price;

  Service({required this.name, this.selected = false, this.price = 0.0});
}

Future<void> saveServices(List<Service> services, String id) async {
  final collectionRef = FirebaseFirestore.instance.collection('email-salons');
  final providerDocRef = collectionRef.doc(id);
  final servicesCollectionRef = providerDocRef.collection('services');
  for (final service in services) {
    if (service.selected) {
      final serviceDocRef = servicesCollectionRef.doc(service.name);
      await serviceDocRef.set({
        'name': service.name,
        'price': service.price,
      });
    }
  }
}

class ServiceList extends ConsumerStatefulWidget {
  const ServiceList({Key? key}) : super(key: key);

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends ConsumerState<ServiceList> {
  final _services = <Service>[
    Service(name: 'Hair Cut'),
    Service(name: 'Hair Spa'),
    Service(name: 'Pedicure'),
    Service(name: 'Manicure'),
    Service(name: 'Waxing'),
    Service(name: 'Body Massage'),
    Service(name: 'Hair Color'),
  ];
  List<Service> selectedServices = [];
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('email-salons')
          .doc(ref.read(idProvider))
          .collection('services')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final services = snapshot.data!.docs;
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...services
                    .map(
                      (service) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '${service['name']}: ${service['price']}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 20),
                        ),
                      ),
                    )
                    .toList(),
              ]);
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ..._services
                  .map(
                    (service) => SizedBox(
                      width: 250,
                      child: Row(
                        children: [
                          Checkbox(
                            value: service.selected,
                            onChanged: (value) {
                              if (value!) {
                                selectedServices.add(service);
                              } else {
                                selectedServices.remove(service);
                              }
                              setState(() {
                                service.selected = value;
                              });
                            },
                          ),
                          Text(service.name),
                          const Spacer(),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              enabled: service.selected,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Price',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  service.price = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    saving = true;
                  });
                  await saveServices(selectedServices, ref.read(idProvider));
                  setState(() {
                    saving = false;
                  });
                },
                child: saving
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ],
          );
        }
      },
    );
  }
}
