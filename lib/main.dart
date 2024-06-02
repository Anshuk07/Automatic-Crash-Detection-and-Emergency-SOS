import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos/home_screen.dart';
import 'package:sos/screens/get_started_screen.dart';
import 'package:sos/screens/home_screen.dart';
import 'package:sos/utils/blue.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  permissionSms();
  getLoginData();

  runApp(const MyApp());
}

void permissionSms() async {
  await [Permission.sms, Permission.location].request();
}

bool? isLogin;

Future<void> _requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.locationWhenInUse,
    Permission.locationAlways,
  ].request();

  // Check the statuses and handle the permissions accordingly
  if (statuses[Permission.bluetoothScan]!.isGranted &&
      statuses[Permission.bluetoothConnect]!.isGranted &&
      (statuses[Permission.locationWhenInUse]!.isGranted ||
          statuses[Permission.locationAlways]!.isGranted)) {
    // Permissions are granted
    print('All required permissions are granted');
  } else {
    // Permissions are not granted
    print('Some permissions are not granted');
  }
}

void getLoginData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  isLogin = prefs.getBool("isLogin");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // Obtain shared preferences.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      showSemanticsDebugger: false,
      title: 'Flutter Sos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GetStartedScreen(),
    );
  }
}
