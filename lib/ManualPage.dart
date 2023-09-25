import 'package:flutter/material.dart';




class ManualPage extends StatelessWidget {
  const ManualPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('User Manual'),
      //backgroundColor: Colors.blue,
    ),
    //drawer: NavigationDrawer(),
    body: Center(child: ElevatedButton(
      child: Text('Press here for a suprise'),
      onPressed: () => {},
    )),
  ); 
}