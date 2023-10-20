import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mysolar/themes/ThemesPage.dart';
import 'package:mysolar/EditProfilePage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        //backgroundColor: Colors.blue,
      ),
      //drawer: NavigationDrawer(),
      body: Column(
        children: <Widget>[
          Center(
            child:           ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ThemesPage()));
            },
            child: Text('Change Theme'),
          ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
              },
              child: Text('Edit Profile')),
          )
          
        ],
      ));
}
