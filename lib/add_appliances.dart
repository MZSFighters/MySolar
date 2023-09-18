import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AddAppliances extends StatefulWidget {
  const AddAppliances({Key? key}) : super(key: key);
    
  _AddAppliancesState createState() => _AddAppliancesState();
}

class _AddAppliancesState extends State<AddAppliances> {
    User? user = FirebaseAuth.instance.currentUser;  // Get the current user

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kwController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

void _addApplianceToFirestore() async { //function to add appliance to firestore


  if (_startTime != null && _endTime != null) {
    final startInMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endInMinutes = _endTime!.hour * 60 + _endTime!.minute;

    if (endInMinutes > startInMinutes) {
      // Valid time range
      final applianceData = {
        'userId': user?.uid,  // Include the user's ID
        'name': _nameController.text,
        'kw': double.parse(_kwController.text),
        'startTime': startInMinutes,
        'endTime': endInMinutes,
      };

      await FirebaseFirestore.instance
          .collection('appliances')
          .add(applianceData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appliance added successfully!')),
      );
    } else {
      // Invalid time range
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('End time must be after start time')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Appliances Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to the whole body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50), // Add some distance from the top
            Text("Add your appliance details"),
            SizedBox(height: 20), // Add some distance between the text and the row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Appliance Name"),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                        hintText: 'Enter appliance name',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Electricity Usage (Kw/hr)"),
                      TextFormField(
                        controller: _kwController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),  // Show numeric keyboard
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),  // Allow numbers and a decimal point
                          ],
                          decoration: InputDecoration(
                          hintText: 'Enter Kw',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // Center align vertically
                  children: [
                    Text("Usage Time"),
                    SizedBox(height: 20), // Move down by 20 pixels
                    ElevatedButton(
                      onPressed: () async {
                        await _selectTime(context, true); // Select start time
                        await _selectTime(context, false); // Select end time
                      },
                      child: Text(_startTime == null || _endTime == null
                          ? "Select Time"
                          : "${_startTime!.format(context)} to ${_endTime!.format(context)}"),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center align vertically
                children: [
                  SizedBox(height: 40), // Move down by 20 pixels
                  ElevatedButton(
                    onPressed: _addApplianceToFirestore,
                    child: Text("+"),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),  // Add some space
          Text("Current appliances:"),
          SizedBox(height: 10),
          SizedBox(height: 10),
          Expanded( //populate a lsit with information from the database
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appliances')
                  .where('userId', isEqualTo: user?.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    final startTime = TimeOfDay(minute: data['startTime'] % 60, hour: data['startTime'] ~/ 60);
                    final endTime = TimeOfDay(minute: data['endTime'] % 60, hour: data['endTime'] ~/ 60);
                    return ListTile(
                      title: Text(data['name']),
                      subtitle: Text("Kw: ${data['kw']}, Time: ${startTime.format(context)} to ${endTime.format(context)}"),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}