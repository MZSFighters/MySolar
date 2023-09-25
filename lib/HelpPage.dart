import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Help'),
      //backgroundColor: Colors.blue,
    ),
    //drawer: NavigationDrawer(),
    body: Center(child: ElevatedButton(
      child: Text('Press here for literally nothing'),
      onPressed: () => {},
    )),
  );
}