import 'package:clipngo_web/providers/selected_services_provider.dart';
import 'package:flutter/material.dart';
import 'package:clipngo_web/widgets/check_box_element.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptedServices extends ConsumerStatefulWidget {
  const OptedServices({
    super.key,
  });

  @override
  ConsumerState<OptedServices> createState() => _OptedServicesState();
}

class _OptedServicesState extends ConsumerState<OptedServices> {
  List<String> dummyServices = [
    "Select Services",
    "Haircut",
    "HairSpa",
    "Facial"
  ];
  Map<String, double> dummyServiceCharges = {
    "Select Services": 0,
    "Haircut": 150,
    "HairSpa": 500,
    "Facial": 600,
  };
  // String _selectedService = "Select Services";
  late final Map<String, bool> _isSelected = {};
  // double _totalCost = 0;

  @override
  void initState() {
    super.initState();
    for (String service in dummyServices) {
      _isSelected[service] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedServices = ref.read(selectedServicesProvider);
    print(selectedServices);
    return DropdownButton(
      value: dummyServices[0],
      items: dummyServices.map((service) {
        return DropdownMenuItem(
          enabled: false,
          value: service,
          child: Expanded(
            child: service != "Select Services"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$service (₹${dummyServiceCharges[service]})"),
                      CheckBoxElement(
                        currentService: service,
                        onSelected: _isSelected,
                        serviceCharges: dummyServiceCharges,
                      ),
                    ],
                  )
                : Text(service),
          ),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }
}
