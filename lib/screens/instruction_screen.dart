import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sos/screens/home_screen.dart';
import 'package:sos/screens/login_screen.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key, required this.isFromHome});
  final bool isFromHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            const Text(
              "INSTRUCTIONS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.67,
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Color(0xff1E1D1D),
                  borderRadius: BorderRadius.circular(20)),
              child: const Column(
                children: [
                  Text(
                    '''1. Add emergency emergency contacts in the app's settings and mark them for SOS alerts. \n \n2. Tap the SOS button or perform the specified action to activate SOS.\n\n3. Customize SOS by choosing pre-written messages or selecting preferred emergency services.''',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(27.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isFromHome)
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 55,
                        width: 150,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 236, 236),
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Back",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  if (!isFromHome)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterForm(
                                isEdit: false,
                              ),
                            ));
                      },
                      child: Container(
                        height: 55,
                        width: 150,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 236, 236),
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
