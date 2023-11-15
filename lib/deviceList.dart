// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/device.dart';
import 'database_functionality/data_repository.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'models/time.dart';
import 'addDevice.dart';

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
    return Scaffold(
      // used to be container incase problems
      floatingActionButton: addDeviceWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
          // leading: BackButton(
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          title: Text('Your Appliances')),
      body: Column(
        children: [
          Expanded(child: DeviceList()),
        ],
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
        stream: DataRepository.getStream(),
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

    device.on = device.checkIfOn(DateTime.now());
    return GestureDetector(
      onTap: () async {
        setState(() {
          switch (device.manualState) {
            case "null":
              device.manualState = "off";
              break;
            case "off":
              device.manualState = "on";
              break;

            case "on":
              device.manualState = "null";
              break;
          }
          DataRepository.updateDevice(device);
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
                color: device.on
                    ? Color.fromRGBO(236, 155, 48, 0.886)
                    : Color.fromRGBO(238, 245, 255, 0.875)),
            child: makeListTile(device)),
      ),
    );
  }

  makeDialog(context, snapshot) {
    final nameFormKey = GlobalKey<FormState>();
    final powerFormKey = GlobalKey<FormState>();
    final startTimeFormKey = GlobalKey<FormState>();
    final endTimeFormKey = GlobalKey<FormState>();
    BuildContext dialogContext;
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;

        Device device = Device.devices.firstWhere((element) =>
            element.id == snapshot.data?.docs.elementAt(widget.index).id);

        final TextEditingController _nameController = TextEditingController();
        _nameController.text = device.name;
        final TextEditingController _kwController = TextEditingController();
        _kwController.text = "${device.kw}";
        final TextEditingController _startTimeController =
            TextEditingController();
        _startTimeController.text =
            "${Time.convertToHourMinutes(device.time.startTime)}";
        final TextEditingController _endTimeController =
            TextEditingController();
        _endTimeController.text =
            "${Time.convertToHourMinutes(device.time.endTime)}";

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      "Modify Appliance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Center(child: Text("Appliance Name")),
                  Form(
                    key: nameFormKey,
                    child: TextFormField(
                      controller: _nameController,
                      validator: validateNameInput,
                    ),
                  ),
                  Center(child: Text("Start Time")),
                  Form(
                    key: startTimeFormKey,
                    child: TextFormField(
                      validator: validateTimeInput,
                      controller: _startTimeController,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true), // Show numeric keyboard
                      inputFormatters: [
                        MaskedInputFormatter('##:##')
                      ], // Allow numbers and a decimal point
                    ),
                  ),
                  Text("end time"),
                  Form(
                    key: endTimeFormKey,
                    child: TextFormField(
                      validator: validateTimeInput,
                      controller: _endTimeController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [MaskedInputFormatter('##:##')],
                    ),
                  ),
                  Text("Power Consumption (kw/h)"),
                  Form(
                    key: powerFormKey,
                    child: TextFormField(
                      validator: validatePowerInput,
                      controller: _kwController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              if (nameFormKey.currentState!.validate() &&
                                  powerFormKey.currentState!.validate() &&
                                  startTimeFormKey.currentState!.validate() &&
                                  endTimeFormKey.currentState!.validate()) {
                                update(
                                    device,
                                    _startTimeController,
                                    _endTimeController,
                                    _nameController,
                                    _kwController);
                                Navigator.pop(dialogContext);
                              }
                            },
                            child: Text("Update",
                                style: TextStyle(color: Colors.white))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              delete(device);
                              Navigator.pop(dialogContext);
                            },
                            child: Text("Delete",
                                style: TextStyle(color: Colors.black))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? validateTimeInput(value) {
    if (value.isEmpty) {
      return "Time must not be empty";
    }
    if (value.length != 5 || !Time.validateInputTime(value)) {
      return "Time must be a valid 24-hr time";
    }
    return null;
  }

  String? validateNameInput(value) {
    if (value.isEmpty) {
      return "Name must not be empty";
    }
    return null;
  }

  String? validatePowerInput(value) {
    if (value.isEmpty) {
      return "Must specify a power value";
    }

    if (double.tryParse(value) == null) {
      return "must be a valid float value";
    }

    return null;
  }

  update(
      Device device,
      TextEditingController startTimeController,
      TextEditingController endTimeController,
      TextEditingController nameController,
      TextEditingController kwController) {
    var time = Time.makeTime(startTimeController.text, endTimeController.text);
    device.name = nameController.text;
    device.kw = double.parse(kwController.text);
    device.time = time;
    DataRepository.updateDevice(device);
  }

  void delete(Device device) {
    DataRepository.deleteDevice(device);
  }

  makeListTile(Device device) {
    return ListTile(
      title: Row(
        children: [
          Text(
            device.name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          if (device.manualState != "null")
            Text(
              " (manually set ${device.manualState})",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
