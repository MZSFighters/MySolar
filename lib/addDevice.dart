import 'package:flutter/material.dart';
import 'models/device.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'models/time.dart';
import "database_functionality/data_repository.dart";

class addDeviceWidget extends StatefulWidget {
  const addDeviceWidget({
    super.key,
  });

  @override
  State<addDeviceWidget> createState() => _addDeviceWidgetState();
}

class _addDeviceWidgetState extends State<addDeviceWidget> {
  final nameFormKey = GlobalKey<FormState>();
  final powerFormKey = GlobalKey<FormState>();
  final startTimeFormKey = GlobalKey<FormState>();
  final endTimeFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _kwController = TextEditingController();
    final TextEditingController _startTimeController = TextEditingController();
    final TextEditingController _endTimeController = TextEditingController();

    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Text(
                                    "Add a new Appliance",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 20.00),
                                  child: Center(child: Text("Appliance Name")),
                                ),
                                Form(
                                  key: nameFormKey,
                                  child: TextFormField(
                                    controller: _nameController,
                                    validator: validateNameInput,
                                    decoration: const InputDecoration(
                                      hintText: 'Appliance Name',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const Text("Enter power usage (kw/hr)"),
                              Form(
                                key: powerFormKey,
                                child: TextFormField(
                                  validator: validatePowerInput,
                                  controller: _kwController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    hintText: 'kw',
                                  ),
                                ),
                              ),
                              const Text("Enter Start Time"),
                              Form(
                                key: startTimeFormKey,
                                child: TextFormField(
                                  controller: _startTimeController,
                                  validator: validateTimeInput,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal:
                                              true), // Show numeric keyboard
                                  inputFormatters: [
                                    MaskedInputFormatter('00:00')
                                  ], // Allow numbers and a decimal point
                                  decoration: const InputDecoration(
                                    hintText: 'start time',
                                  ),
                                ),
                              ),
                              const Text("Enter End time"),
                              Form(
                                key: endTimeFormKey,
                                child: TextFormField(
                                  validator: validateTimeInput,
                                  controller: _endTimeController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    MaskedInputFormatter('00:00')
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'end time',
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20.00, bottom: 2.00),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameFormKey.currentState!.validate() &&
                                  powerFormKey.currentState!.validate() &&
                                  startTimeFormKey.currentState!.validate() &&
                                  endTimeFormKey.currentState!.validate()) {
                                Device device = Device(
                                    name: _nameController.text,
                                    time: Time.makeTime(
                                        _startTimeController.text,
                                        _endTimeController.text),
                                    kw: int.parse(_kwController.text));

                                DataRepository.addDevice(device);
                                _nameController.text = "";
                                _kwController.text = "";
                                _startTimeController.text = "";
                                _endTimeController.text = "";
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Add Appliance"),
                          ),
                        ),
                      ),
                    ]),
              ));
            });
      },
      label: const Text("Add Appliance"),
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

    if (int.tryParse(value) == null) {
      return "must be a valid integer value";
    }

    return null;
  }
}
