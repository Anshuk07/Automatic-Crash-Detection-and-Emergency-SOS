import 'package:flutter/material.dart';
import 'package:sos/main.dart';
import 'package:sos/screens/home_screen.dart';
import 'package:sos/screens/instruction_screen.dart';
import 'package:sos/screens/login_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  void initState() {
    // TODO: implement initState
    changePage();
    super.initState();
  }

  void changePage() async {
    await Future.delayed(Duration(seconds: 1), () {
      if (isLogin == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InstructionScreen(isFromHome: false),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color(0xff14152f)),
        child: Image.asset("assets/sos.jpeg"),
      ),
    );
  }
}
