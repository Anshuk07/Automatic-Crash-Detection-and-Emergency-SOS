import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:sos/utils/helper_functions.dart';

class BluetoothController extends GetxController {
  BluetoothConnection? _connection;
  Timer? _dialogTimer;
  String address = "";
  RxBool isConnected = false.obs;
  RxBool isListening = false.obs;

  @override
  void onClose() {
    disconnect();
    _dialogTimer?.cancel();
    super.onClose();
  }

  Future<void> enableBluetooth() async {
    // Request Bluetooth to be turned on if it's not already
    final BluetoothState state = await FlutterBluetoothSerial.instance.state;
    if (state == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      isConnected.value = true;
    }
  }

  Future<void> disableBluetooth() async {
    await FlutterBluetoothSerial.instance.requestDisable();
    isConnected.value = false;
    isListening.value = false;
  }

  void connectToDevice(BluetoothDevice device) async {
    address = device.address;
    print(address);

    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      print('Connected to the device');
      isListening.value = true;

      _connection!.input!.listen((Uint8List data) {
        _handleData(data);
      }).onDone(() {
        print('Disconnected by remote request');
        _cleanupConnection();
      });
    } catch (exception) {
      Get.snackbar("Error", "Devic Not Found!", colorText: Colors.white);
    }
  }

  void _handleData(Uint8List data) {
    String message = ascii.decode(data);
    print('Received data: $message');

    double value;
    try {
      value = double.parse(message.trim());
    } catch (e) {
      print('Error parsing message: $e');
      return;
    }

    if (value > 10) {
      sendMessageToAll();
      disconnect();
    } else if (value > 6) {
      _showDialogWithTimer();
    }

    // Sending data back if necessary
    _connection?.output.add(data);

    if (message.contains('!')) {
      disconnect();
    }
  }

  void _showDialogWithTimer() {
    _dialogTimer?.cancel(); // Cancel any existing timer
    Get.dialog(
      AlertDialog(
        title: Text('Alert'),
        content: CountdownWidget(
          onCountdownComplete: () {
            sendMessageToAll();
            Get.back(); // Close the dialog if it's still open
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _dialogTimer?.cancel();
              Get.back();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );

    _dialogTimer = Timer(Duration(seconds: 30), () {
      sendMessageToAll();
      Get.back(); // Close the dialog if it's still open
    });
  }

  void disconnect() {
    _connection?.finish();
    _cleanupConnection();
    isConnected.value = false;
    isListening.value = false;
    print('Disconnected by local host');
  }

  void _cleanupConnection() {
    _connection?.dispose();
    _connection = null;
  }
}

class CountdownWidget extends StatefulWidget {
  final VoidCallback onCountdownComplete;

  CountdownWidget({required this.onCountdownComplete});

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _countdownTimer;
  int _remainingTime = 30;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        timer.cancel();
        widget.onCountdownComplete();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Time remaining: $_remainingTime seconds'),
      ],
    );
  }
}
