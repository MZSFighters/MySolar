import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:mysolar/CustomTheme.dart';
import 'package:mysolar/features/app/splash_screen/splash_screen.dart';
import 'package:mysolar/features/user_auth/presentation/pages/home_page.dart';
import 'package:mysolar/features/user_auth/presentation/pages/login_page.dart';
import 'package:mysolar/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:mysolar/weather/current_forecast.dart';
import 'package:mysolar/load_shedding/load_shedding.dart';
import 'package:mysolar/themes.dart';
import 'package:mysolar/CustomTheme.dart';
import 'devices.dart';

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
        '/home': (context) => HomePage(),
        '/devices': (context) => SelectDevice(),
        '/weather_pg': (context) => CurrentWeatherPage(),
        '/loadshedding_pg': (context) => LoadShedding()
      },
    );
  }
}
