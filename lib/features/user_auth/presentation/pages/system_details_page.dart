import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mysolar/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
// import 'package:mysolar/features/user_auth/presentation/pages/home_page.dart';
// import 'package:mysolar/features/user_auth/presentation/pages/login_page.dart';
import 'package:photo_view/photo_view.dart';


class systemDetailsIInformation extends StatefulWidget {
  const systemDetailsIInformation({super.key});

  @override
  State<systemDetailsIInformation> createState() => _systemDetailsIInformationPage();
}

class _systemDetailsIInformationPage extends State<systemDetailsIInformation> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _maxPowerOutputController = TextEditingController();
  TextEditingController _batteryCapacityController = TextEditingController();
  TextEditingController _lowestBatteryPercentageController = TextEditingController();
  TextEditingController _maxInverterCapacityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _numberError = '';

  final USER = FirebaseAuth.instance.currentUser?.uid.toString();

  @override
  void initState() {
    super.initState();
    DatabaseReference dbRef = FirebaseDatabase.instance.ref("systemDetailsInformation/$USER");
    dbRef.onValue.listen((event) {
      if(event.snapshot.exists){
        setState(() {
          Map powerInfo = event.snapshot.value as Map;
          powerInfo["key"] = event.snapshot.key;
          _maxPowerOutputController.text = powerInfo["maxPowerOutput"];
          _batteryCapacityController.text = powerInfo["batteryCapacity"];
          _lowestBatteryPercentageController.text = powerInfo["lowestBatteryPercentage"];
          _maxInverterCapacityController.text = powerInfo["maxInverterCapacity"];
        });
      }else{
        print("no data");
      }
    });
  }

  @override
  void dispose() {
    _maxPowerOutputController.dispose();
    _batteryCapacityController.dispose();
    _lowestBatteryPercentageController.dispose();
    _maxInverterCapacityController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("System Details Information"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ //assets/mysolar_diagram.png
                Text(
                  "System Details Information",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                  GestureDetector(
                  onTap: () => _openZoomableImage(context),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.asset('assets/mysolar_diagram.png',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.zoom_in, color: Colors.black),
                      ),
                      ],
                    ),
                  ),
              SizedBox(height: 20),
                Text(
                  "Please enter the following information about your solar power system:",
                  style: TextStyle(fontSize: 14 ),
                ),
                SizedBox(height: 30),
                _buildInputRow("[1] Solar Panels Max Output (kW/hr) :", _maxPowerOutputController),
                _buildInputRow("[2] Maximum Battery Storage (kW) :", _batteryCapacityController),
                _buildInputRow("[3] Lowest Acceptable Battery Percentage % :", _lowestBatteryPercentageController, isPercentage: true),
                _buildInputRow("[4] Maximum Inverter Power Threshold (kW)", _maxInverterCapacityController),
                SizedBox(height: 30),
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
                      )
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildInputRow(String label, TextEditingController controller, {bool isPercentage = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: TextStyle(fontSize: 14, fontWeight:FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a number.';
              } else if (isPercentage) {
                final numValue = double.tryParse(value);
                if (numValue == null || numValue < 0 || numValue > 100) {
                  return 'Enter a percentage (0-100)';
                }
              } else if (double.tryParse(value) == null) {
                return 'Invalid number format.';
              }
              return null;
            },
          ),
        ),
      ],
    ),
  );
}


void _openZoomableImage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(),
        body: Container(
          child: PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.white),
            imageProvider: AssetImage('assets/mysolar_diagram.png'),
          ),
        ),
      ),
    ));
  }

  void _power() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref("systemDetailsInformation/$USER");
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;
      double maxPowerOutput = double.parse(_maxPowerOutputController.text);
      double batteryCapacity = double.parse(_batteryCapacityController.text);
      double lowestBatteryPercentage = double.parse(_lowestBatteryPercentageController.text);
      double maxInverterCapacity = double.parse(_maxInverterCapacityController.text);
      Map<String, dynamic> powerInfo = {
        'userID': uid.toString(),
        'maxPowerOutput': maxPowerOutput,
        'batteryCapacity': batteryCapacity,
        'lowestBatteryPercentage': lowestBatteryPercentage,
        'maxInverterCapacity' : maxInverterCapacity,
      };

      await dbRef!.set(powerInfo).whenComplete(() {
        Navigator.pushNamed(context, "/home");
      });
    }
  }
}
