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
  Map<String, dynamic>? data;
  List<dynamic> days = [];
  /*Map<String, dynamic> tempData = {
    "events": [
      {
        "end": "2023-09-21T10:30:00+02:00",
        "note": "Stage 8 (TESTING: current)",
        "start": "2023-09-21T08:00:00+02:00"
      }
    ],
    "info": {
      "name":
          "TESTING University of the Witwatersrand Research Site and Sports (3)",
      "region": "Eskom Direct, City of Johannesburg, Gauteng"
    },
    "schedule": {
      "days": [
        {
          "date": "2023-09-21",
          "name": "Thursday",
          "stages": [
            ["22:00-00:30"],
            ["14:00-16:30", "22:00-00:30"],
            ["06:00-08:30", "14:00-16:30", "22:00-00:30"],
            ["06:00-08:30", "14:00-16:30", "22:00-00:30"],
            ["06:00-08:30", "14:00-16:30", "22:00-00:30"],
            ["06:00-08:30", "14:00-18:30", "22:00-00:30"],
            ["06:00-10:30", "14:00-18:30", "22:00-00:30"],
            ["06:00-10:30", "14:00-18:30", "22:00-00:30"]
          ]
        },
        {
          "date": "2023-09-22",
          "name": "Friday",
          "stages": [
            [],
            ["22:00-00:30"],
            ["14:00-16:30", "22:00-00:30"],
            ["06:00-08:30", "14:00-16:30", "22:00-00:30"],
            ["00:00-02:30", "06:00-08:30", "14:00-16:30", "22:00-00:30"],
            ["00:00-02:30", "06:00-08:30", "14:00-16:30", "22:00-00:30"],
            ["00:00-02:30", "06:00-08:30", "14:00-18:30", "22:00-00:30"],
            ["00:00-02:30", "06:00-10:30", "14:00-18:30", "22:00-00:30"]
          ]
        },
        {
          "date": "2023-09-23",
          "name": "Saturday",
          "stages": [
            ["06:00-08:30"],
            ["06:00-08:30"],
            ["06:00-08:30", "22:00-00:30"],
            ["06:00-08:30", "14:00-16:30", "22:00-00:30"],
            ["06:00-10:30", "14:00-16:30", "22:00-00:30"],
            ["00:00-02:30", "06:00-10:30", "14:00-16:30", "22:00-00:30"],
            ["00:00-02:30", "06:00-10:30", "14:00-16:30", "22:00-00:30"],
            ["00:00-02:30", "06:00-10:30", "14:00-18:30", "22:00-00:30"]
          ]
        },
        {
          "date": "2023-09-24",
          "name": "Sunday",
          "stages": [
            ["14:00-16:30"],
            ["06:00-08:30", "14:00-16:30"],
            ["06:00-08:30", "14:00-16:30"],
            ["06:00-08:30", "14:00-16:30", "22:00-00:30"],
            ["06:00-08:30", "14:00-18:30", "22:00-00:30"],
            ["06:00-10:30", "14:00-18:30", "22:00-00:30"],
            ["00:00-02:30", "06:00-10:30", "14:00-18:30", "22:00-00:30"],
            ["00:00-02:30", "06:00-10:30", "14:00-18:30", "22:00-00:30"]
          ]
        },
        {
          "date": "2023-09-25",
          "name": "Monday",
          "stages": [
            ["20:00-22:30"],
            ["12:00-14:30", "20:00-22:30"],
            ["04:00-06:30", "12:00-14:30", "20:00-22:30"],
            ["04:00-06:30", "12:00-14:30", "20:00-22:30"],
            ["04:00-06:30", "12:00-14:30", "20:00-00:30"],
            ["04:00-06:30", "12:00-16:30", "20:00-00:30"],
            ["04:00-08:30", "12:00-16:30", "20:00-00:30"],
            ["00:00-02:30", "04:00-08:30", "12:00-16:30", "20:00-00:30"]
          ]
        },
        {
          "date": "2023-09-26",
          "name": "Tuesday",
          "stages": [
            [],
            ["20:00-22:30"],
            ["12:00-14:30", "20:00-22:30"],
            ["04:00-06:30", "12:00-14:30", "20:00-22:30"],
            ["04:00-06:30", "12:00-14:30", "20:00-22:30"],
            ["04:00-06:30", "12:00-14:30", "20:00-00:30"],
            ["04:00-06:30", "12:00-16:30", "20:00-00:30"],
            ["04:00-08:30", "12:00-16:30", "20:00-00:30"]
          ]
        },
        {
          "date": "2023-09-27",
          "name": "Wednesday",
          "stages": [
            ["04:00-06:30"],
            ["04:00-06:30"],
            ["04:00-06:30", "20:00-22:30"],
            ["04:00-06:30", "12:00-14:30", "20:00-22:30"],
            ["04:00-08:30", "12:00-14:30", "20:00-22:30"],
            ["04:00-08:30", "12:00-14:30", "20:00-22:30"],
            ["04:00-08:30", "12:00-14:30", "20:00-00:30"],
            ["04:00-08:30", "12:00-16:30", "20:00-00:30"]
          ]
        }
      ],
      "source": "https://example.com/test.schedule/current"
    }
  };*/

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// Method that requests the load shedding data
  // @pragma('vm:entry-point', true)
Future<void> fetchData() async {
  print("fetched data");
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
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error:$e');
  }
}


  List<dynamic> dayTimes(int stageNo, int dayNo) {
    List<dynamic> scheduleDays = data!['schedule']['days'];
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
            //return times;
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
    //final double screenWidth = MediaQuery.of(context).size.width;
    //final double screenHeight = MediaQuery.of(context).size.height;
    //final double marginValue = screenWidth * 0.1;
    //final double topmargin = screenHeight * 0.01;
    if (data == null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Load Shedding Page"),
            backgroundColor: Colors.deepOrange,
          ),
          body: Center(child: CircularProgressIndicator()),
        );
      }
      
  if(jsonData.isNotEmpty){
    data = json.decode(jsonData);


  }
    

    int stageNo = int.parse((data!['events'][0]['note'])[6]);

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

    return Scaffold(
            appBar: AppBar(
              title: const Text("Load Shedding Page"),
              // backgroundColor: Colors.deepOrange,
            ),
            body: SingleChildScrollView(
                child: Center(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  //margin: EdgeInsets.only(top: topmargin),
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
                        //height: screenHeight,
                        width: 200,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration:
                            BoxDecoration(color: Colors.deepOrange), //shade200
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
                        //height: screenHeight,
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
                        //height: screenHeight,
                        //padding: const EdgeInsets.symmetric(horizontal: 14),
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
                        //height: screenHeight,
                        //padding: const EdgeInsets.symmetric(horizontal: 14),
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
                        //height: screenHeight,
                        //padding: const EdgeInsets.symmetric(horizontal: 14),
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
                        //height: screenHeight,
                        //padding: const EdgeInsets.symmetric(horizontal: 14),
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
            ))));
  }
}
//${(tempData['events'][0]['note'])[6]}