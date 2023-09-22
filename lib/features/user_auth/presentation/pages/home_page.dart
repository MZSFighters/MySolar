import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
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
        ],
      ),
    );
  }
}
