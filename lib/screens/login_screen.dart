import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos/database/database.dart';
import 'package:sos/models/person_model.dart';
import 'package:sos/models/user_info_model.dart';
import 'package:sos/screens/home_screen.dart';
import 'package:sos/screens/instruction_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.isEdit});
  final bool isEdit;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _emergencyNumberController1 =
      TextEditingController();
  final TextEditingController _emergencyNumberController2 =
      TextEditingController();
  final TextEditingController _emergencyNumberController3 =
      TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.isEdit) {
      getUserInfo();
    }
    super.initState();
  }

  void getUserInfo() async {
    UserInfo? val = await _databaseHelper.getUserInfo();
    print("adsolhjakhdashdjkashdajkshdakjhdaksjhd");
    if (val != null) {
      _nameController.text = val!.name;
      _addressController.text = val!.address;
      _bloodGroupController.text = val!.bloodGroup;
      _licenseNumberController.text = val.licenseNumber;
      _vehicleNumberController.text = val!.vehicleNumber;
    }
  }

  void setLoginData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Update Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/sos.png"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      "Register for SOS",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _bloodGroupController,
                  decoration: InputDecoration(
                    labelText: 'Blood Group',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your blood group';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _licenseNumberController,
                  decoration: InputDecoration(
                    labelText: 'License Number',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your license number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _vehicleNumberController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Number',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your vehicle number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                if (!widget.isEdit)
                  TextFormField(
                    controller: _emergencyNumberController1,
                    decoration: InputDecoration(
                      labelText: 'Emergency Number 1',
                      labelStyle: TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your emergency number';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (!widget.isEdit)
                  TextFormField(
                    controller: _emergencyNumberController2,
                    decoration: InputDecoration(
                      labelText: 'Emergency Number 2',
                      labelStyle: TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your emergency number';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (!widget.isEdit)
                  TextFormField(
                    controller: _emergencyNumberController3,
                    decoration: InputDecoration(
                      labelText: 'Emergency Number 3',
                      labelStyle: TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your emergency number';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (widget.isEdit) {
                      print("update called");
                      await _databaseHelper.updateUserInfo(UserInfo(
                          name: _nameController.text,
                          address: _addressController.text,
                          bloodGroup: _bloodGroupController.text,
                          licenseNumber: _licenseNumberController.text,
                          vehicleNumber: _vehicleNumberController.text));
                    } else {
                      await _databaseHelper.insertUserInfo(UserInfo(
                          name: _nameController.text,
                          address: _addressController.text,
                          bloodGroup: _bloodGroupController.text,
                          licenseNumber: _licenseNumberController.text,
                          vehicleNumber: _vehicleNumberController.text));
                    }

                    if (_emergencyNumberController1.text.isNotEmpty) {
                      await _databaseHelper.insertPerson(Person(
                          name: "",
                          phoneNumber: _emergencyNumberController1.text));
                    }
                    if (_emergencyNumberController2.text.isNotEmpty) {
                      await _databaseHelper.insertPerson(Person(
                          name: "",
                          phoneNumber: _emergencyNumberController2.text));
                    }
                    if (_emergencyNumberController3.text.isNotEmpty) {
                      await _databaseHelper.insertPerson(Person(
                          name: "",
                          phoneNumber: _emergencyNumberController3.text));
                    }
                    setLoginData();

                    setState(() {
                      isLoading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                  },
                  child: Container(
                    height: 55,
                    width: 200,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 236, 236),
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              widget.isEdit ? "Edit User Info" : "Register",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
