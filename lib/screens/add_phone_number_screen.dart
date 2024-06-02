import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sos/database/database.dart';
import 'package:sos/models/person_model.dart';

class AddPhoneNumberScreen extends StatefulWidget {
  const AddPhoneNumberScreen({super.key});

  @override
  State<AddPhoneNumberScreen> createState() => AddPhoneNumberScreenState();
}

class AddPhoneNumberScreenState extends State<AddPhoneNumberScreen> {
  List<Person> persons = [];
  final _databaseHelper = DatabaseHelper();
  void addPersion({required Person person}) async {
    if (persons.length >= 5) {
      Fluttertoast.showToast(
          msg: "You can only add at most five numbers",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    await _databaseHelper.insertPerson(person);
    setState(() {
      persons.add(person);
    });
  }

  void getPersons() async {
    persons = await _databaseHelper.getPersons();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getPersons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Add Emergency Numbers",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/sos.png"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          TextEditingController nameController = TextEditingController();
          TextEditingController phoneNumberController = TextEditingController();
          final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
          Get.bottomSheet(Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 250, 247, 247)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: const TextStyle(color: Colors.blue),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (value.length != 10) {
                          return 'Phone number must be 10 digits';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: const TextStyle(color: Colors.blue),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          addPersion(
                              person: Person(
                                  name: nameController.text,
                                  phoneNumber: phoneNumberController.text));
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        height: 44,
                        width: 200,
                        margin: const EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Add Number",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
        },
        child: const Text(
          "Add",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 241, 236, 236),
            Color.fromARGB(255, 124, 123, 123)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              const Text(
                "Emergency Numbers",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              for (int i = 0; i < persons.length; i++)
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${i + 1}",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                persons[i].name.isEmpty
                                    ? "Emergency Number ${i + 1}"
                                    : persons[i].name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                persons[i].phoneNumber,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () async {
                            await _databaseHelper.deletePerson(i + 1);
                            setState(() {
                              persons.removeAt(i);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 40,
                          ))
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
