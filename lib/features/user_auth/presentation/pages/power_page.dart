import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mysolar/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:mysolar/features/user_auth/presentation/pages/home_page.dart';
import 'package:mysolar/features/user_auth/presentation/pages/login_page.dart';
import 'package:mysolar/features/user_auth/presentation/widgets/form_container_widget.dart';


class PowerPage extends StatefulWidget {
  const PowerPage({super.key});

  @override
  State<PowerPage> createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _maxOutputController = TextEditingController();
  TextEditingController _maxStorageController = TextEditingController();
  TextEditingController _lowLevelController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _numberError = '';

  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('powerInformation');

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('powerInformation');
  }

  @override
  void dispose() {
    _maxOutputController.dispose();
    _maxStorageController.dispose();
    _lowLevelController.dispose();
    super.dispose();
  }

  void _validateNumber(String input) {
    if (input.isEmpty) {
      setState(() {
        _numberError = 'Please enter a number.';
      });
      return;
    }
    // Use double.tryParse to check if the input is a valid number.
    else if (double.tryParse(input) == null) {
      setState(() {
        _numberError = 'Invalid number format.';
      });
      return;
    }
    else { // Clear any previous error message.
      setState(() {
        _numberError = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Power Information"),
        backgroundColor: Colors.deepOrange, // appbar color.
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Power Information",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _maxOutputController,
                hintText: "Total PowerOutput : kW/h",
                isPasswordField: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a number.';
                  }
                  else if (double.tryParse(value) == null) {
                    return 'Invalid number format.';
                  }
                  return null;
                },
              ),
              Text(
                _numberError,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(

                controller: _maxStorageController,
                hintText: "Total battery capacity : kW/h",
                isPasswordField: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a number.';
                  }
                  else if (double.tryParse(value) == null) {
                    return 'Invalid number format.';
                  }
                  return null;
                },
              ),
              Text(
                _numberError,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _lowLevelController,
                hintText: "Lowest battery usage: %",
                isPasswordField: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a number.';
                  }
                  else if (double.tryParse(value) == null) {
                    return 'Invalid number format.';
                  }
                  return null;
                },
              ),
              Text(
                _numberError,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _power,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
        ),
      ),
    );
  }

  void _power() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      String output = _maxOutputController.text;
      String capacity = _maxStorageController.text;
      String limitUsage = _lowLevelController.text;
      final uid = user?.uid;
      Map<String, String> powerInfo = {
        'userID': uid.toString(),
        'powerOutput': output,
        'powerCapacity': capacity,
        'limitedUsage': limitUsage,
      };

      await dbRef!.push().set(powerInfo).whenComplete(() {
        Navigator.pushNamed(context, "/home");
      });
    }
  }
}