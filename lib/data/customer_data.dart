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
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      assignedStylist: json['assignedStylist'],
      optedServices: json['optedServices'],
      serviceCharge: json['serviceCharge'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'assignedStylist': assignedStylist,
      'optedServices': optedServices,
      'serviceCharge': serviceCharge,
    };
  }
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
