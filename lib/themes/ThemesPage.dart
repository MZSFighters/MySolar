import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mysolar/themes/CustomTheme.dart';
import 'package:mysolar/themes/themes.dart';
import 'package:mysolar/SettingsPage.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Themes'),
          //backgroundColor: Colors.blue,
        ),
        //drawer: NavigationDrawer(),
        body: Center(
            child: Column(children: <Widget>[
          ElevatedButton(
              onPressed: () {
                setState(() {
                  CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.BLUE);
                });
              },
              child: Text('Blue')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  CustomTheme.instanceOf(context)
                      .changeTheme(MyThemeKeys.GREEN);
                });
              },
              child: Text('Green')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  CustomTheme.instanceOf(context)
                      .changeTheme(MyThemeKeys.ORANGE);
                });
              },
              child: Text('Orange')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.RED);
                });
              },
              child: Text('Red')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.PINK);
                });
              },
              child: Text('Pink')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  CustomTheme.instanceOf(context)
                      .changeTheme(MyThemeKeys.PURPLE);
                });
              },
              child: Text('Purple')),
        ])),
      );
}
