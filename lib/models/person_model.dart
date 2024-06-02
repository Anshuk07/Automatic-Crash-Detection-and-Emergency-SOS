class Person {
  final String name;
  final String phoneNumber;

  Person({required this.name, required this.phoneNumber});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
