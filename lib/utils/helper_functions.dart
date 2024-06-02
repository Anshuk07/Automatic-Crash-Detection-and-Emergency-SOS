import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sos/database/database.dart';
import 'package:sos/models/person_model.dart';
import 'package:sos/models/user_info_model.dart';

const platform = MethodChannel('sendSms');
Position? _currentPosition;
List<Person>? persons;
UserInfo? user;
void sendMessageToAll() async {
  print("location access called");
  _currentPosition = await _determinePosition();
  final databaseHelper = DatabaseHelper();
  persons = await databaseHelper.getPersons();
  user = await databaseHelper.getUserInfo();
  for (Person e in persons!) {
    _sendMessage(
        name: "${user!.name}",
        phoneNumber: e.phoneNumber,
        address: "${user!.address}",
        bloodGroup: "${user!.bloodGroup}",
        licenseNumber: "${user!.licenseNumber}",
        vehicleNumber: "${user!.vehicleNumber}");
  }

  print("sms sent");
  Fluttertoast.showToast(
      msg: "SMS Sent",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

void _sendMessage(
    {required String name,
    required String phoneNumber,
    required String address,
    required String bloodGroup,
    required String licenseNumber,
    required String vehicleNumber}) {
  // Clear text fields after sending
  sendSms(
      name: name,
      number: phoneNumber,
      address: address,
      bloodGroup: bloodGroup,
      licenseNumber: licenseNumber,
      vehicleNumber: vehicleNumber);
}

Future<Position> _determinePosition() async {
  return await Geolocator.getCurrentPosition();
}

Future<Null> sendSms(
    {required String name,
    required String number,
    required String address,
    required String bloodGroup,
    required String licenseNumber,
    required String vehicleNumber}) async {
  print("SendSMS");
  try {
    String mapLink = "";
    print("Blood Group : $bloodGroup");
    final String result = await platform.invokeMethod('send', <String, dynamic>{
      "phone": "+91$number",
      "msg":
          "Accident Occurred${"\n"}Name: ${name}${"\n"}Blood Gp: ${bloodGroup}${"\n"}License: ${licenseNumber}${"\n"}Vehicle No: ${vehicleNumber} Location: http://maps.google.com/maps?q=${_currentPosition!.latitude},${_currentPosition!.longitude}"
    }); //Replace a 'X' with 10 digit phone number
    print(result);
  } on PlatformException catch (e) {
    print(e.toString());
  }
}
