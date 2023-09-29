// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/device.dart';
import 'database_functionality/data_repository.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'models/time.dart';

class SelectDevice extends StatefulWidget {
  const SelectDevice({super.key});

  @override
  State<SelectDevice> createState() => _SelectDeviceState();
}

class _SelectDeviceState extends State<SelectDevice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Your Devices",
      home: Scaffold(
        floatingActionButton: addDeviceWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(title: Text("Devices")),
        body: Column(
          children: [
            DeviceList(),
          ],
        ),
      ),
    );
  }
}

//Yoni's addDevice as a DialogBox
class addDeviceWidget extends StatefulWidget {
  const addDeviceWidget({
    super.key,
  });

  @override
  State<addDeviceWidget> createState() => _addDeviceWidgetState();
}

class _addDeviceWidgetState extends State<addDeviceWidget> {
  @override
  Widget build(BuildContext context) {
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

    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SizedBox(height: 50), // Add some distance from the top
                    Text("Add your appliance details"),
                    SizedBox(
                        height:
                            20), // Add some distance between the text and the row
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
                      ],
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Electricity Usage (Kw/hr)"),
                          TextFormField(
                            controller: _kwController,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true), // Show numeric keyboard
                            inputFormatters: [
                              MaskedInputFormatter('##:##')
                            ], // Allow numbers and a decimal point
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
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center align vertically
                        children: [
                          Text("Usage Time"),
                          SizedBox(height: 20), // Move down by 20 pixels
                          ElevatedButton(
                            onPressed: () async {
                              await _selectTime(
                                  context, true); // Select start time
                              await _selectTime(
                                  context, false); // Select end time
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
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center align vertically
                      children: [
                        SizedBox(height: 40), // Move down by 20 pixels
                        ElevatedButton(
                          onPressed: () {
                            Device device = Device(
                                name: _nameController.text,
                                startTime: Time.handleTimeOfDay(_startTime!),
                                endTime: Time.handleTimeOfDay(_endTime!),
                                kw: int.parse(_kwController.text));

                            DataRepository dr = DataRepository();
                            dr.addDevice(device);
                          },
                          child: Text("+"),
                        ),
                      ],
                    ),
                  ]));
            });
      },
      label: Text("Add Device"),
    );
  }
}

//List of devices
class DeviceList extends StatefulWidget {
  const DeviceList({
    super.key,
  });

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DataRepository.collection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CustomListTile(snapshot, index);
              },
            );
          } else {
            return LinearProgressIndicator();
          }
        });
  }

  StreamSubscription sub = DataRepository.getStream().listen((event) {
    Device.devices = event.docs
        .map((e) => Device(
            id: e.id,
            name: e['name'],
            startTime: e['startTime'],
            endTime: e['endTime'],
            kw: e['kw']))
        .toList();

    print("FUCCCCCCCCCCCK");
  });
}

class CustomListTile extends StatefulWidget {
  AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final int index;

  CustomListTile(
    this.snapshot,
    this.index, {
    super.key,
  });

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        makeDialog(context, widget.snapshot);
      },
      title: Text("${widget.snapshot.data!.docs[widget.index]['name']}"),
    );
  }

  //Dialog Box

  makeDialog(context, snapshot) {
    BuildContext dialogContext;
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        Device device = Device.devices.firstWhere((element) =>
            element.id == snapshot.data?.docs.elementAt(widget.index).id);

        return Dialog(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    update(device);
                    Navigator.pop(dialogContext);
                  },
                  child: Text("Pick Times")),
              TextButton(
                  onPressed: () {
                    update(device);
                    Navigator.pop(dialogContext);
                  },
                  child: Text("Update"))
            ],
          ),
        );
      },
    );
  }

  update(Device device) {
    DataRepository dataRepository = DataRepository();
  }
}
