import 'package:flutter/material.dart';
import 'models/device.dart';
import 'database_functionality/data_repository.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'models/time.dart';

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
    final TextEditingController _startTimeController = TextEditingController();
    final TextEditingController _endTimeController = TextEditingController();

    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const SizedBox(
                        height: 50), // Add some distance from the top
                    const Text("Add your appliance details"),
                    const SizedBox(
                        height:
                            20), // Add some distance between the text and the row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Appliance Name"),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter appliance name',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                              child: Column(
                            children: [
                              const Text("Electricity Usage (Kw/hr)"),
                              TextFormField(
                                controller: _kwController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true), // Show numeric keyboard
                                inputFormatters: [
                                  MaskedInputFormatter('00:00')
                                ], // Allow numbers and a decimal point
                                decoration: const InputDecoration(
                                  hintText: 'kw',
                                ),
                              ),
                              const Text("Enter Start Time"),
                              TextFormField(
                                controller: _startTimeController,
                                validator: validateTimeInput,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true), // Show numeric keyboard
                                inputFormatters: [
                                  MaskedInputFormatter('00:00')
                                ], // Allow numbers and a decimal point
                                decoration: const InputDecoration(
                                  hintText: 'start time',
                                ),
                              ),
                              const Text("Enter End time"),
                              TextFormField(
                                controller: _endTimeController,
                                validator: validateTimeInput,
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
                            ],
                          ))
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center align vertically
                      children: [
                        const SizedBox(height: 40), // Move down by 20 pixels
                        ElevatedButton(
                          onPressed: () {
                            Device device = Device(
                                name: _nameController.text,
                                time: Time.makeTime(_startTimeController.text,
                                    _endTimeController.text),
                                kw: int.parse(_kwController.text));
                            DataRepository dr = DataRepository();
                            dr.addDevice(device);
                            //
                            _nameController.text = "";
                            _kwController.text = "";
                            _startTimeController.text = "";
                            _endTimeController.text = "";
                            Navigator.pop(context);
                          },
                          child: const Text("+"),
                        ),
                      ],
                    ),
                  ]));
            });
      },
      label: const Text("Add Device"),
    );
  }

  String? validateTimeInput(value) {
    if (value == null) {
      return "Please Enter a Valid Number";
    }
    if (value.length != 5) {
      return "Input must be of the form hh:mm";
    }
    if (int.parse(value.substring(0, 2)) >= 24 ||
        int.parse(value.substring(3, 5)) >= 60) {
      return "Invalid Time";
    }
    return null;
  }
}
