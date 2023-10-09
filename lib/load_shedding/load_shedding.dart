import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoadShedding extends StatefulWidget {
  const LoadShedding({super.key});

  @override
  State<LoadShedding> createState() => _LoadSheddingState();
}

class _LoadSheddingState extends State<LoadShedding> {
  String jsonData = '';
  Map<String, dynamic> data = {};
  List<dynamic> days = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// Method that requests the load shedding data
  Future<void> fetchData() async {
    //print("fetched data");

    final url = Uri.https('developer.sepush.co.za', '/business/2.0/area', {
      'id':
          'eskde-3-universityofthewitwatersrandresearchsiteandsportscityofjohannesburggauteng',
      'test': 'current'
    });
    final headers = {
      'Token': 'F294A5CF-965A40F4-A8515DE0-DA856EDD',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final decodeData = json.decode(response.body);
        //print(decodeData);
        setState(() {
          jsonData = json.encode(decodeData);
        });
      } else {
        setState(() {
          jsonData = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        jsonData = 'Error:$e';
      });
    }
  }

  List<dynamic> dayTimes(int stageNo, int dayNo) {
    List<dynamic> scheduleDays = data['schedule']['days'];
    List<dynamic> times = [];
    int count = 0;
    for (var day in scheduleDays) {
      count += 1;
      if (dayNo == count) {
        List<dynamic> stages = day['stages'];
        var s_length = 0;
        if (dayNo == 0) {
          days.add(day['name'] + " - Today");
        } else {
          days.add(day['name'] + " - " + day['date']);
        }
        for (var stage in stages) {
          s_length += 1;
          if (s_length == stageNo) {
            for (var timeSlot in stage) {
              times.add(timeSlot);
            }
          }
        }
        break;
      }
    }
    return times;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (jsonData.isNotEmpty) {
      data = json.decode(jsonData);
    }

    int stageNo = int.parse((data['events'][0]['note'])[6]);

    List<dynamic> firstDay = dayTimes(stageNo, 1);
    String dayZero = days[0];

    List<dynamic> secondDay = dayTimes(stageNo, 2);
    String dayOne = days[1];

    List<dynamic> thirdDay = dayTimes(stageNo, 3);
    String dayTwo = days[2];

    List<dynamic> fourthDay = dayTimes(stageNo, 4);
    String dayThree = days[3];

    List<dynamic> fifthDay = dayTimes(stageNo, 5);
    String dayFour = days[4];

    List<dynamic> sixthDay = dayTimes(stageNo, 6);
    String dayFive = days[5];

    List<dynamic> seventhDay = dayTimes(stageNo, 7);
    String daySix = days[6];

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Load Shedding Page"),
              backgroundColor: Colors.deepOrange,
            ),
            body: SingleChildScrollView(
                child: Center(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: const Text(
                    'Load Shedding Schedule',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10, bottom: 15),
                    child: Text("Current Stage: $stageNo",
                        style: const TextStyle(
                            fontSize: 16.0, fontStyle: FontStyle.italic))),
                Container(
                    width: 200,
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.0, color: Colors.deepOrange)),
                    child: Column(children: [
                      Container(
                        width: 200,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(color: Colors.deepOrange),
                        child: Text(
                          dayZero,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      for (var i in firstDay)
                        Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: Text(i.toString()))
                    ])),
                Container(
                    width: 200,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black),
                    ),
                    child: Column(children: [
                      Container(
                        width: 200,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(color: Colors.black),
                        child: Text(
                          dayOne,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      for (var i in secondDay)
                        Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: Text(i.toString()))
                    ])),
                Container(
                    width: 200,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.black)),
                    child: Column(children: [
                      Container(
                        width: 200,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(color: Colors.black),
                        child: Text(
                          dayTwo,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      for (var i in thirdDay)
                        Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: Text(i.toString()))
                    ])),
                Container(
                    width: 200,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.black)),
                    child: Column(children: [
                      Container(
                        width: 200,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(color: Colors.black),
                        child: Text(
                          dayThree,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      for (var i in fourthDay)
                        Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: Text(i.toString()))
                    ])),
                Container(
                    width: 200,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.black)),
                    child: Column(children: [
                      Container(
                        width: 200,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(color: Colors.black),
                        child: Text(
                          dayFour,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      for (var i in fifthDay)
                        Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: Text(i.toString()))
                    ])),
                Container(
                    width: 200,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.black)),
                    child: Column(children: [
                      Container(
                        width: 200,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(color: Colors.black),
                        child: Text(
                          dayFive,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      for (var i in sixthDay)
                        Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: Text(i.toString()))
                    ])),
                Container(
                    width: 200,
                    margin: EdgeInsets.only(top: 10, bottom: 15),
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.black)),
                    child: Column(children: [
                      Container(
                        width: 200,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(color: Colors.black),
                        child: Text(
                          daySix,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      for (var i in seventhDay)
                        Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: Text(i.toString()))
                    ]))
              ],
            )))));
  }
}
