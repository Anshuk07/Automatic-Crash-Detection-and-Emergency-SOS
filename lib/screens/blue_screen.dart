// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// class BluetoothConnectionPage extends StatefulWidget {
//   @override
//   _BluetoothConnectionPageState createState() =>
//       _BluetoothConnectionPageState();
// }

// class _BluetoothConnectionPageState extends State<BluetoothConnectionPage> {
//   BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

//   @override
//   void initState() {
//     super.initState();

//     // Get current state
//     FlutterBluetoothSerial.instance.state.then((state) {
//       setState(() {
//         _bluetoothState = state;
//       });
//     });

//     // Listen for future state changes
//     FlutterBluetoothSerial.instance
//         .onStateChanged()
//         .listen((BluetoothState state) {
//       setState(() {
//         _bluetoothState = state;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Connection'),
//       ),
//       body: Column(
//         children: <Widget>[
//           SwitchListTile(
//             title: const Text('Enable Bluetooth'),
//             value: _bluetoothState.isEnabled,
//             onChanged: (bool value) {
//               // Do the request and update with the true value then
//               future() async {
//                 if (value)
//                   await FlutterBluetoothSerial.instance.requestEnable();
//                 else
//                   await FlutterBluetoothSerial.instance.requestDisable();
//               }

//               future().then((_) {
//                 setState(() {});
//               });
//             },
//           ),
//           ListTile(
//             title: ElevatedButton(
//               child: Text('Connect to Device'),
//               onPressed: () async {
//                 final BluetoothDevice selectedDevice =
//                     await Navigator.of(context).push(
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           SelectBondedDevicePage(checkAvailability: false)),
//                 );

//                 if (selectedDevice != null) {
//                   print('Connect -> selected device $selectedDevice');
//                   _startChat(context, selectedDevice);
//                 } else {
//                   print('Connect -> no device selected');
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _startChat(BuildContext context, BluetoothDevice server) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) {
//           return ChatPage(server: server);
//         },
//       ),
//     );
//   }
// }

// class SelectBondedDevicePage extends StatelessWidget {
//   final bool checkAvailability;

//   const SelectBondedDevicePage({this.checkAvailability = true});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Device'),
//       ),
//       body: FutureBuilder<List<BluetoothDevice>>(
//         future: FlutterBluetoothSerial.instance.getBondedDevices(),
//         initialData: [],
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView(
//               children: snapshot.data!.map((device) {
//                 return ListTile(
//                   title: Text(device.name ?? ""),
//                   subtitle: Text(device.address.toString()),
//                   onTap: () async {
//                     print(device.address);
//                     // BluetoothConnection connection =
//                     //     await BluetoothConnection.toAddress(device.address);
//                     // print('Connected to the device');

//                     // Some simplest connection :F
//                     try {
//                       BluetoothConnection connection =
//                           await BluetoothConnection.toAddress(device.address);
//                       print('Connected to the device');

//                       connection.input!.listen((Uint8List data) {
//                         print('Data incoming: ${ascii.decode(data)}');
//                         connection.output.add(data); // Sending data

//                         if (ascii.decode(data).contains('!')) {
//                           connection.finish(); // Closing connection
//                           print('Disconnecting by local host');
//                         }
//                       }).onDone(() {
//                         print('Disconnected by remote request');
//                       });
//                     } catch (exception) {
//                       print('Cannot connect, exception occured');
//                     }
//                   },
//                 );
//               }).toList(),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class ChatPage extends StatefulWidget {
//   final BluetoothDevice server;

//   const ChatPage({required this.server});

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   BluetoothConnection? connection;
//   List<String> messages = [];
//   final TextEditingController textEditingController = TextEditingController();
//   bool isConnecting = true;
//   bool isDisconnecting = false;

//   @override
//   void initState() {
//     super.initState();
//     _connectToServer();
//   }

//   @override
//   void dispose() {
//     if (connection != null && connection!.isConnected) {
//       isDisconnecting = true;
//       connection!.dispose();
//       connection = null;
//     }
//     super.dispose();
//   }

//   void _connectToServer() async {
//     try {
//       connection = await BluetoothConnection.toAddress(widget.server.address);
//       setState(() {
//         isConnecting = false;
//       });
//       connection!.input!.listen(_onDataReceived).onDone(() {
//         if (isDisconnecting) {
//           print('Disconnecting locally!');
//         } else {
//           print('Disconnected remotely!');
//         }
//         if (mounted) {
//           setState(() {});
//         }
//       });
//     } catch (exception) {
//       print('Cannot connect, exception occurred');
//     }
//   }

//   void _onDataReceived(Uint8List data) {
//     setState(() {
//       messages.add(ascii.decode(data));
//     });
//   }

//   void _sendMessage(String text) async {
//     if (text.isNotEmpty) {
//       try {
//         connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
//         await connection!.output.allSent;
//         setState(() {
//           messages.add(text);
//         });
//       } catch (e) {
//         print('Error sending message: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${widget.server.name}'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(messages[index]),
//                 );
//               },
//             ),
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: TextField(
//                   controller: textEditingController,
//                   decoration: InputDecoration(
//                     hintText: 'Type your message...',
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () {
//                   _sendMessage(textEditingController.text);
//                   textEditingController.clear();
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:sos/controllers/blue_controller.dart'; // Make sure to import the BluetoothController

class SelectBondedDevicePage extends StatelessWidget {
  final bool checkAvailability;

  const SelectBondedDevicePage({this.checkAvailability = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Device'),
      ),
      body: FutureBuilder<List<BluetoothDevice>>(
        future: FlutterBluetoothSerial.instance.getBondedDevices(),
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.map((device) {
                return ListTile(
                  title: Text(device.name ?? ""),
                  subtitle: Text(device.address.toString()),
                  onTap: () {
                    Get.find<BluetoothController>().connectToDevice(device);
                    Get.snackbar(
                      "Bluetooth Connected",
                      "You are now ready to go",
                      colorText: Colors.white,
                    );
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
