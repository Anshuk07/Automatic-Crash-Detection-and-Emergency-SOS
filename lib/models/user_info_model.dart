import 'package:sos/models/person_model.dart';

class UserInfo {
  final String name;
  final String address;
  final String bloodGroup;
  final String licenseNumber;
  final String vehicleNumber;

  UserInfo({
    required this.name,
    required this.address,
    required this.bloodGroup,
    required this.licenseNumber,
    required this.vehicleNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'bloodGroup': bloodGroup,
      'licenseNumber': licenseNumber,
      'vehicleNumber': vehicleNumber,
    };
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'],
      address: json['address'],
      bloodGroup: json['bloodGroup'],
      licenseNumber: json['licenseNumber'],
      vehicleNumber: json['vehicleNumber'],
    );
  }
}
