import 'package:clipngo_web/providers/selected_services_provider.dart';
import 'package:clipngo_web/providers/total_cost_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckBoxElement extends ConsumerStatefulWidget {
  const CheckBoxElement({
    super.key,
    required this.currentService,
    required this.onSelected,
    required this.serviceCharges,
  });

  final String currentService;
  // final List<String> selectedServices;
  final Map<String, bool> onSelected;
  final Map<String, double> serviceCharges;
  @override
  ConsumerState<CheckBoxElement> createState() => _CheckBoxElementState();
}

class _CheckBoxElementState extends ConsumerState<CheckBoxElement> {
  @override
  Widget build(BuildContext context) {
    final seletedServices = ref.watch(selectedServicesProvider);
    return Checkbox(
      value: widget.onSelected[widget.currentService],
      onChanged: (value) {
        setState(
          () {
            widget.onSelected[widget.currentService] = value!;
            // print(value);
            if (widget.onSelected[widget.currentService] == true) {
              // widget.selectedServices.add(widget.currentService);
              seletedServices.add(widget.currentService);
              ref.watch(totalCostProvider.notifier).state +=
                  widget.serviceCharges[widget.currentService]!;
              print(seletedServices);
              print(ref.read(totalCostProvider.notifier).state);
            } else if (widget.onSelected[widget.currentService] == false &&
                seletedServices.contains(widget.currentService)) {
              seletedServices.remove(widget.currentService);
              ref.watch(totalCostProvider.notifier).state -=
                  widget.serviceCharges[widget.currentService]!;
              print(seletedServices);
              print(ref.read(totalCostProvider.notifier).state);
            }
          },
        );
      },
    );
  }
}
