// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class SendMessageWidget extends StatefulWidget {
//   const SendMessageWidget({super.key});

//   @override
//   _SendMessageWidgetState createState() => _SendMessageWidgetState();
// }

// class _SendMessageWidgetState extends State<SendMessageWidget> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _messageController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   static const platform = MethodChannel('sendSms');
//   Position? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void getLocation() async {
//     print("location access called");
//     _currentPosition = await _determinePosition();
//     _sendMessage();
//   }

//   void _sendMessage() {
//     if (_formKey.currentState!.validate()) {
//       String message = _messageController.text;
//       String phoneNumber = _phoneNumberController.text;

//       // Clear text fields after sending
//       sendSms(msg: message, number: phoneNumber);
//       print("sms sent");
//       Fluttertoast.showToast(
//           msg: "SMS Sent",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       _messageController.clear();
//       _phoneNumberController.clear();
//     }
//   }

//   Future<Position> _determinePosition() async {
//     return await Geolocator.getCurrentPosition();
//   }

//   Future<Null> sendSms({required String msg, required String number}) async {
//     print("SendSMS");
//     try {
//       String mapLink = "";
//       final String result =
//           await platform.invokeMethod('send', <String, dynamic>{
//         "phone": "+91$number",
//         "msg":
//             "Accident occured to ${msg} at the position ${"\n"}Latitude :  ${_currentPosition!.latitude} Longitude: ${_currentPosition!.longitude} ${"\n"} Location: http://maps.google.com/maps?q=${_currentPosition!.latitude},${_currentPosition!.longitude}",
//       }); //Replace a 'X' with 10 digit phone number
//       print(result);
//     } on PlatformException catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Send SOS',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               const SizedBox(
//                 height: 20,
//               ),
//               TextFormField(
//                 controller: _phoneNumberController,
//                 decoration: const InputDecoration(
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                     labelText: 'Phone Number',
//                     prefixIcon: Icon(
//                       Icons.phone,
//                       color: Colors.black87,
//                     ),
//                     border: OutlineInputBorder(borderSide: BorderSide())),
//                 keyboardType: TextInputType.phone,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a phone number';
//                   }
//                   if (value.length != 10) {
//                     return 'Phone number must be 10 digits';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 30.0),
//               TextFormField(
//                 controller: _messageController,
//                 decoration: const InputDecoration(
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                     prefixIcon: Icon(
//                       Icons.person,
//                       color: Colors.black87,
//                     ),
//                     labelText: 'Name',
//                     border: OutlineInputBorder(borderSide: BorderSide())),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Your name';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 30.0),
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [
//                       Color.fromARGB(255, 163, 8, 112),
//                       Color.fromARGB(255, 54, 8, 92)
//                     ],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: getLocation,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                     child: const Text(
//                       'Send',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
