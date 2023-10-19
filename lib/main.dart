import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysolar/battery_output_calculation/finalOutputCalculation.dart';
import 'package:mysolar/device_consumption_and_use/deviceConsumption.dart';
import 'package:mysolar/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:mysolar/graph/graph.dart';
import 'package:mysolar/themes/CustomTheme.dart';
import 'package:mysolar/features/app/splash_screen/splash_screen.dart';
import 'package:mysolar/features/user_auth/presentation/pages/home_page.dart';
import 'package:mysolar/features/user_auth/presentation/pages/login_page.dart';
import 'package:mysolar/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:mysolar/weather/current_forecast.dart';
import 'package:mysolar/load_shedding/load_shedding.dart';
import 'package:mysolar/themes/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'deviceList.dart';
import 'cloudCoverageSolarCoverage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ************* mockdata for graph ************ //

// // hourly kw in battery
// List<double> generateMockData() {
//   final random = Random();
//   return List.generate(25, (index) {
//     double value = random.nextDouble() * 20 - 10;
//     return double.parse(value.toStringAsFixed(3));
//   });
// }

// List<double> powerConsumption() {
//   List<double> powerUsage = <double>[];
//   List<Device> devices = Device.devices;
//   PowerUsageTracker put = PowerUsageTracker();
//   try {
//     put.updatePowerUsageForDay(devices);
//   DateTime currentDate = DateTime.now();
//   for (int hour = 0; hour < 24; hour++) {
//     DateTime currentHourTime = currentDate.add(Duration(hours: hour));
//     DateTime startTime = currentHourTime;
//     DateTime endTime = currentHourTime.add(Duration(hours: hour));
//     int differenceInHours = endTime.difference(startTime).inHours;

//     double x = put.getPowerUsageForHour(differenceInHours);

//     powerUsage.add(x);
//   }

// } catch (e) {
//     print("Error: $e");
// }

//   powerUsage.add(0);
//   return powerUsage;
// }

// List<List<String>> appliancesUsage() {
//   List<List<String>> all_appliances = [];

//   List<Device> devices = <Device>[];
//   for (int i = 0; i < Device.devices.length; i++) {
//     devices.add(Device.devices[i]);
//   }
//   DateTime currentDate = DateTime.now();
//   PowerUsageTracker put = PowerUsageTracker();
//   put.updatePowerUsageForDay(devices);
//   for (int hour = 0; hour < 24; hour++) {
//     List<String> hourly_appliances = [];
//     DateTime currentHourTime = currentDate.add(Duration(hours: hour));
//     List<Device> y = put.getDevicesForHour(
//         int.parse(currentHourTime.toString()) -
//             int.parse((currentHourTime.add(Duration(hours: hour))).toString()));
//     for (int i = 0; i < y.length; i++) {
//       hourly_appliances.add(y[i].name);
//     }
//     all_appliances.add(hourly_appliances);
//   }
//   return all_appliances;
// }

// final List<double> hourlyKw = powerConsumption();

// final List<List<String>> hourlyAppliances = appliancesUsage();

// // random applainces used durimg an hour

// List<List<String>> generateApplianceData() {
//   final List<String> appliances = ["light", "geyser", "wifi", "stove", "oven"];
//   final random = Random();

//   return List.generate(12, (index) {
//     int numberOfAppliances =
//         random.nextInt(5) + 1; // At least one appliance and at most 5
//     return List.generate(numberOfAppliances,
//         (i) => appliances[random.nextInt(appliances.length)]);
//   });
// }

//final List<List<String>> hourlyAppliances = generateApplianceData();

// ************************ //

//final output calculation

String? getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

// get the consumpiton data for each hour
Future<List<double>> calculateHourlyConsumption() async {
  String? userId = getCurrentUserId();

  if (userId == null) {
    throw Exception("User is not logged in");
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DeviceConsumption deviceConsumption =
      DeviceConsumption(userId: userId, firestore: firestore);

  // Get the hourly consumption data from devices
  List<double> deviceHourlyConsumption =
      await deviceConsumption.calculateHourlyConsumption();

  return deviceHourlyConsumption;
}

// get devices on at each hour

Future<List<List<String>>> calculateDevicesOnEachHour() async {
  String? userId = getCurrentUserId();

  if (userId == null) {
    throw Exception("User is not logged in");
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DeviceConsumption deviceConsumption =
      DeviceConsumption(userId: userId, firestore: firestore);

  // get the list of devices on for each hour
  List<List<String>> devicesOnEachHour =
      await deviceConsumption.devicesOnEachHour();
  return devicesOnEachHour;
}

//final energy usage :
Future<List<Map<String, dynamic>>> finalOutputData() async {
  List<double> consumptionData = await calculateHourlyConsumption();

  FinalOutputCalculation finalCalculation = FinalOutputCalculation(
    batterySize: 10.0, // dummy
    lowestBatteryPercentage: 10, //  dummy
    maxPower: 15.0, //dummy value
    consumptionData: consumptionData, //fetched data
  );

  List<Map<String, dynamic>> outputData =
      await finalCalculation.calculateFinalOutput();
  return outputData;
}

final Future<List<Map<String, dynamic>>> outputData = finalOutputData();

final Future<List<double>> consumptionData = calculateHourlyConsumption();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBmPwbtqEVJyYB0Lpsfj6soG5Vi-ohficA",
        appId: "1:878845743646:web:d95ee7530329012546140f",
        messagingSenderId: "878845743646",
        projectId: "mysolar-72ca5",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(CustomTheme(
    initialThemeKey: MyThemeKeys.BLUE,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: CustomTheme.of(context),
      // theme: ThemeData(
      //   primarySwatch: Colors.deepOrange,  // Set the primary color to deep orange
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.deepOrange,  // Set the ElevatedButton color to deep orange
      //     ),
      //   ),
      // ),
      routes: {
        '/': (context) => SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => MyHomePage2(),
        '/devices': (context) => SelectDevice(),
        '/weather_pg': (context) => CurrentWeatherPage(),
        '/loadshedding_pg': (context) => LoadShedding(),
        '/graph_pg': (context) => BatteryGraph(
              batterySize: 10,
              hourlyKwFuture: finalOutputData(),
              hourlyAppliancesFuture: calculateDevicesOnEachHour(),
            ),
        '/fetch_pg': (context) => WeatherPage(),
      },
    );
  }
}
