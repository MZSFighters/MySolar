import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          //backgroundColor: Colors.blue,
        ),
        //drawer: NavigationDrawer(),
        body: EditProfileTextFields(),
      );
}

class EditProfileTextFields extends StatefulWidget {
  const EditProfileTextFields({super.key});

  @override
  State<EditProfileTextFields> createState() => _EditProfileTextFieldsState();
}

class _EditProfileTextFieldsState extends State<EditProfileTextFields> {
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPic = TextEditingController();

  @override
  void dispose() {
    controllerName.dispose();
    controllerEmail.dispose();
    controllerPic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: controllerName,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Enter your full name",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: controllerEmail,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Enter your email address"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: controllerPic,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.portrait),
                  labelText: "Enter in the url of your picture"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Info Saved")));
            },
            child: Text('Save'),
          )
        ]),
      );
}
