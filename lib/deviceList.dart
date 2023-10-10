// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
        appBar: AppBar(
            leading: BackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Center(child: Text(" Your Devices"))),
        body: Column(
          children: [
            Expanded(child: DeviceList()),
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
    return GestureDetector(
      onTap: () async {
        setState(() {
          device.on = !device.on;
        });
      },
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: !device.on
                    ? Color.fromRGBO(126, 126, 126, 0.894)
                    : Color.fromRGBO(134, 182, 255, 0.878)),
            child: makeListTile(device)),
      ),
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
                    update(device, _startTimeController, _endTimeController);
                    Navigator.pop(dialogContext);
                  },
                  child: Text("Update"))
            ],
          ),
        );
      },
    );
  }

  update(Device device, TextEditingController startTimeController,
      TextEditingController endTimeController) {
    var time = Time.makeTime(startTimeController.text, endTimeController.text);
    device.time = time;
    dr.updateDevice(device);
  }

  makeListTile(Device device) {
    device.checkIfOn();
    return ListTile(
      title: Row(
        children: [
          Text(
            device.name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      subtitle: Column(
        children: [
          Row(
            children: [
              Text("Start Time: "),
              Text(
                "${Time.convertToHourMinutes(device.time.startTime)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Text("End Time:"),
              Text(
                "${Time.convertToHourMinutes(device.time.endTime)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(padding: EdgeInsets.all(2.0)),
          Row(
            children: [
              Text("Power Consumption:"),
              Text(
                "${device.kw} kw",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
      trailing: SizedBox(
        width: 40,
        child: TextButton(
            onPressed: () {
              makeDialog(context, widget.snapshot);
            },
            child: Icon(Icons.more_vert,
                color: const Color.fromARGB(255, 0, 0, 0), size: 30.0)),
      ),
    );
  }
}
