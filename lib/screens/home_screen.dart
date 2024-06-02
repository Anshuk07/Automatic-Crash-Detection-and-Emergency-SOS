import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sos/controllers/blue_controller.dart';
import 'package:sos/screens/add_phone_number_screen.dart';
import 'package:sos/screens/blue_screen.dart';
import 'package:sos/screens/instruction_screen.dart';
import 'package:sos/screens/login_screen.dart';
import 'package:sos/utils/blue.dart';
import 'package:sos/utils/helper_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BluetoothController bt = Get.put(BluetoothController());

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
  }

  Future<void> requestBluetoothPermissions() async {
    var status = await Permission.bluetoothConnect.status;
    if (!status.isGranted) {
      await Permission.bluetoothConnect.request();
    }

    status = await Permission.bluetoothScan.status;
    if (!status.isGranted) {
      await Permission.bluetoothScan.request();
    }

    status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "SAVE OUR SOULS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/sos.png"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Obx(() => Switch(
                value: bt.isConnected.value,
                onChanged: (val) {
                  if (val) {
                    bt.enableBluetooth();
                  } else {
                    bt.disableBluetooth();
                  }
                })),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 5, 1, 29),
          Color.fromARGB(255, 2, 7, 29)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InstructionScreen(
                                isFromHome: true,
                              ),
                            ));
                      },
                      child: GlossyContainer(
                        height: 142,
                        width: 150,
                        borderRadius: BorderRadius.circular(10),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/mandatory.png",
                                height: 70,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Instructions",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterForm(
                                isEdit: true,
                              ),
                            ));
                      },
                      child: GlossyContainer(
                        height: 142,
                        width: 150,
                        borderRadius: BorderRadius.circular(10),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/save-instagram.png",
                                height: 70,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Saved Details",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPhoneNumberScreen(),
                            ));
                      },
                      child: GlossyContainer(
                        height: 142,
                        width: 150,
                        borderRadius: BorderRadius.circular(10),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/emergency-call.png",
                                height: 70,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Emergency Numbers",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SelectBondedDevicePage(
                                checkAvailability: false,
                              ),
                            ));
                      },
                      child: GlossyContainer(
                        height: 142,
                        width: 150,
                        borderRadius: BorderRadius.circular(10),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/bluetooth.png",
                                height: 70,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Connect",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),

              Obx(() => Column(
                    children: [
                      if (bt.isListening.value)
                        Lottie.asset('assets/Animation - 1717314338592.json',
                            height: 200),
                    ],
                  ))

              // Text("Connected")
            ],
          ),
        ),
      ),
    );
  }
}
