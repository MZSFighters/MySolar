import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mysolar/SettingsPage.dart';
import 'package:mysolar/ManualPage.dart';
import 'package:mysolar/deviceList.dart';
import 'package:mysolar/features/user_auth/presentation/pages/clock.dart';
import 'package:mysolar/load_shedding/load_shedding.dart';
import 'package:mysolar/weather/api_call.dart';
import 'package:mysolar/weather/current_forecast.dart';
import 'package:mysolar/HelpPage.dart';
import 'package:mysolar/database_functionality/data_repository.dart';
import 'package:mysolar/weather/current_weather_widget.dart';
import 'package:mysolar/weather/models.dart';
import 'package:one_clock/one_clock.dart';

String? getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}


class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key});

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {

  var weatherModel;

  @override
  void initState() {
    getWeather();
    super.initState();
  }

    getWeather() async{
    weatherModel = await WeatherAPICall().request();
    setState(() {
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('Home'),
    ),
    drawer: NavigationDrawer(),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Location_Date_Widget(),
            SizedBox(
              height: 160,
              width: 160,
              child: MyAnalogClock(),
            ),
            
            if (weatherModel != null)
            CurrentWeatherWidget(
              temperature: weatherModel!.currentWeather["temperature"], 
              weatherCode: weatherModel!.currentWeather["weathercode"], 
              winddirection: weatherModel!.currentWeather["windspeed"], 
              windspeed: weatherModel!.currentWeather["winddirection"], 
              isDay: weatherModel!.currentWeather["is_day"]
              ),
              Positioned(
                top: 600,
                left: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/graph_pg");
              },
              child: Text("view predicted battery power & grid usage"),
            ),
                ),
              Positioned(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/fetch_pg");
                  },
                  child: Text('fetch weather conditions'),
                ),
              ),
              Positioned(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/weather_pg");
                  },
                  child: Text('weather page'),
                ),
              ),
              Positioned(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/devices");
                  },
                  child: Text('manage appliances'),
                ),
              ),
              Positioned(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/loadshedding_pg");
                  },
                  child: Text('loadshedding schedule'),
                ),
              ),
          ],
        ),
      )
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DataRepository dr = DataRepository();
    // weatherModel;
    getWeather() async {
      var weatherModel = await WeatherAPICall().request();
    }
    return Scaffold(

  );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataRepository dr = DataRepository();
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        //backgroundColor: Colors.deepOrange,
        //foregroundColor: Colors.white,
      ),
      drawer: NavigationDrawer(),
      body: Stack(
        children: <Widget>[
          Positioned(

            child: MyAnalogClock(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Welcome Home buddy!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                // onTap: () {
                //   FirebaseAuth.instance.signOut();
                //   Navigator.pop(context, "/login");
                // },
                child: Container(
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Sign out",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 1,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/graph_pg");
              },
              child: Text("Graph Page"),
            ),
          ),
          Positioned(
            top: 50,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/fetch_pg");
              },
              child: Text("fetch weather"),
            ),
          ),
          Positioned(
            top: 1,
            left: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/weather_pg");
              },
              child: Text("Weather Page"),
            ),
          ),
          Positioned(
            top: 50,
            left: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/loadshedding_pg");
              },
              child: Text("Load Shedding Page"),
            ),
          ),
          Positioned(
            top: 100,
            left: 100,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/devices");
              },
              child: Text("Appliances"),
            ),
          )
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  String Picture =
      'https://upload.wikimedia.org/wikipedia/en/a/a4/Hide_the_Pain_Harold_%28Andr%C3%A1s_Arat%C3%B3%29.jpg';
  String Name = 'Welcome';
  var email = getCurrentUserId();

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BuildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget BuildHeader(BuildContext context) => Container(
        //color: Colors.blue,
        color: Colors.grey,
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage(
              Picture,
            ),
          ),
          SizedBox(height: 12),
          Text(
            Name,
            style: TextStyle(fontSize: 28, color: Colors.black),
          ),
          Text(
            email.toString(),
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ]),
      );
//}

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          // ListTile( // user manual/tutorial : will do maybe before final submisison
          //   leading: Icon(Icons.book),
          //   title: Text('User Manual'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => ManualPage()));
          //   },
          // ),
          // ListTile( // help section : will do before final submission maybe?
          //   leading: Icon(Icons.question_mark),
          //   title: Text('Help'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => HelpPage()));
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.sunny),
            title: Text('Weather'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CurrentWeatherPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.solar_power),
            title: Text('Devices'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SelectDevice()));
            },
          ),
          ListTile(
            leading: Icon(Icons.electric_meter),
            title: Text('Loadshedding Schedule'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoadShedding()));
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: Icon(Icons.door_back_door),
            title: Text('Sign Out'),
            onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pop(context, "/login");
                },
          ),
        ],
      );
}
