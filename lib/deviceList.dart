// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/device.dart';
import 'database_functionality/data_repository.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'models/time.dart';
import 'addDevice.dart';

DataRepository dr = DataRepository();

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
    print("Devices which are currently on:");
    for (int i = 0; i < Device.devices.length; i++) {
      if (Device.devices[i].checkIfOn()) {
        print(
            "${Time.convertToHourMinutes(Device.devices[i].time.startTime)}, ${Time.convertToHourMinutes(Device.devices[i].time.endTime)}  ${Device.devices[i].name}");
      }
    }
    return StreamBuilder(
        stream: dr.getStream(),
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
    Device device = Device.devices.firstWhere((element) =>
        element.id == widget.snapshot.data!.docs.elementAt(widget.index).id);
    return ListTile(
      onTap: () {
        makeDialog(context, widget.snapshot);
      },
      title: Text("${device.name}"),
      subtitle: Text("Device is on: ${device.on}"),
    );
  }

  //Dialog Box

  makeDialog(context, snapshot) {
    final TextEditingController _startTimeController = TextEditingController();
    final TextEditingController _endTimeController = TextEditingController();
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
              Text(device.name),
              Text('${device.time.startTime}'),
              Text('${device.time.endTime}'),
              Text("Enter Start Time"),
              TextFormField(
                controller: _startTimeController,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), // Show numeric keyboard
                inputFormatters: [
                  MaskedInputFormatter('##:##')
                ], // Allow numbers and a decimal point
                decoration: InputDecoration(
                  hintText: 'Start Time',
                ),
              ),
              Text("Enter end time"),
              TextFormField(
                controller: _endTimeController,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), // Show numeric keyboard
                inputFormatters: [
                  MaskedInputFormatter('##:##')
                ], // Allow numbers and a decimal point
                decoration: InputDecoration(
                  hintText: 'Enter end time',
                ),
              ),
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

  update(Device device) {}
}
