import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mysolar/SettingsPage.dart';
import 'package:mysolar/ManualPage.dart';
import 'package:mysolar/devices.dart';
import 'package:mysolar/weather/current_forecast.dart';
import 'package:mysolar/HelpPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        //backgroundColor: Colors.deepOrange,
        //foregroundColor: Colors.white,
      ),
      drawer: NavigationDrawer(),
      body: Stack(
        children: [
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
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                },
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
                Navigator.pushNamed(context, "/add_appliances");
              },
              child: Text("Appliances Page"),
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
              child: Text("Devices"),
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
  String Name = 'Muhammad Omar';
  String Email = 'SmoothBrain@smooth.com';

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
        color: Colors.blue,
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
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
          Text(
            Email,
            style: TextStyle(fontSize: 16, color: Colors.white),
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
          ListTile(
            leading: Icon(Icons.book),
            title: Text('User Manual'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ManualPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text('Help'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HelpPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.sunny),
            title: Text('Weather'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CurrentWeatherPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.sunny),
            title: Text('Devices'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SelectDevice()));
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: Icon(Icons.door_back_door),
            title: Text('Log Out'),
            onTap: () => {},
          ),
        ],
      );
}
