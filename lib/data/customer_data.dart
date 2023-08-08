class Customer {
  final String name;
  final String phoneNumber;
  final String assignedStylist;
  final String serviceCharge;
  final String optedServices;

  Customer({
    required this.name,
    required this.phoneNumber,
    required this.assignedStylist,
    required this.serviceCharge,
    required this.optedServices,
  });
}

List<Customer> customers = [
  Customer(
      name: 'John Doe',
      phoneNumber: '1234567890',
      assignedStylist: 'Jane Smith',
      serviceCharge: "345",
      optedServices: "Haircut"),
  Customer(
      name: 'Alice Johnson',
      phoneNumber: '9876543210',
      assignedStylist: 'Bob Williams',
      serviceCharge: "789",
      optedServices: "Beard trim"),
];
