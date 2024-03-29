import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mysolar/SettingsPage.dart';
import 'package:mysolar/ManualPage.dart';
import 'package:mysolar/appWorkings.dart';
import 'package:mysolar/deviceList.dart';
import 'package:mysolar/features/user_auth/presentation/pages/clock.dart';
import 'package:mysolar/features/user_auth/presentation/pages/login_page.dart';
import 'package:mysolar/load_shedding/load_shedding.dart';
import 'package:mysolar/notifications/notifications_calculator.dart';
import 'package:mysolar/weather/api_call.dart';
import 'package:mysolar/weather/current_forecast.dart';
import 'package:mysolar/HelpPage.dart';
import 'package:mysolar/database_functionality/data_repository.dart';
import 'package:mysolar/weather/current_weather_widget.dart';
import 'package:mysolar/weather/models.dart';
import 'package:one_clock/one_clock.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:mysolar/database_functionality/data_repository.dart';

final user = FirebaseAuth.instance.currentUser;
final userEmail = user?.email;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataRepository();

    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: <Widget>[
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            )
          ],
        ),
        drawer: NavigationDrawer(),
        endDrawer: NotificationsDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
              SizedBox(
                height: 200,
                child: Image.asset('assets/logo5_1.png'),
              ),
              Text(
                'Welcome',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              Text(
                userEmail.toString(),
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Positioned(child: Location_Date_Widget()),
              SizedBox(
                height: 150,
                width: 150,
                child: MyAnalogClock(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Positioned(
                    top: 150,
                    left: 70,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(165, 40)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/graph_pg");
                      },
                      child: Text("Prediction Graph"),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    right: 50,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(165, 40)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/power");
                      },
                      child: Text("System Details"),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Positioned(
                    top: 50,
                    right: 50,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(165, 40)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/fetch_pg");
                      },
                      child: Text("Weather Data"),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 50,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(165, 40)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/weather_pg");
                      },
                      child: Text("Weather Page"),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Positioned(
                    top: 50,
                    left: 50,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(165, 40)),
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
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(165, 40)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/devices");
                      },
                      child: Text("Appliances"),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

// ====================================================================
// Class setting up notifications drawer
class NotificationsDrawer extends StatefulWidget {
  const NotificationsDrawer({super.key});

  @override
  State<NotificationsDrawer> createState() => _NotificationsDrawerState();
}

class _NotificationsDrawerState extends State<NotificationsDrawer> {
  List<String> notifications = [];
  bool isLoading = true;

  void fetchNotifications() async {
    setState(() => isLoading = true);
    NotificationsCalculator calculator = NotificationsCalculator();
    notifications = await calculator.calculateNotifications();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('notifications-drawer'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0) {
          fetchNotifications();
        }
      },
      child: Drawer(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : notifications.isEmpty
                ? Center(
                    child: Text('There are no new notifications',
                        style: TextStyle(color: Colors.white)))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationTile(
                          notification: notifications[index]);
                    },
                  ),
      ),
    );
  }
}

// displaying notifications
class NotificationTile extends StatelessWidget {
  final String notification;

  const NotificationTile({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notification),
      textColor: Colors.white,
      // add more styling and functionality as needed
    );
  }
}

//===========================================
// Class for navigation drawer / side menu

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  String Picture =
      'https://upload.wikimedia.org/wikipedia/en/a/a4/Hide_the_Pain_Harold_%28Andr%C3%A1s_Arat%C3%B3%29.jpg';
  String Name = 'Welcome';
  var email = userEmail;

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
        color: Colors.white,
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
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('How the app works'),
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AppWorkings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.sunny),
            title: Text('Weather'),
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CurrentWeatherPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.solar_power),
            title: Text('Appliances'),
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SelectDevice()));
            },
          ),
          ListTile(
            leading: Icon(Icons.electric_meter),
            title: Text('Loadshedding Schedule'),
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoadShedding()));
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: Icon(Icons.door_back_door),
            title: Text('Sign Out'),
            textColor: Colors.white,
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
            },
          ),
        ],
      );
}
