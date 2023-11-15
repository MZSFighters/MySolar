// notifications.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysolar/models/system_details.dart';
import 'package:mysolar/battery_output_calculation/finalOutputCalculation.dart';
import 'package:mysolar/device_consumption_and_use/deviceConsumption.dart';
import 'package:mysolar/load_shedding/fetch_today_schedule.dart';

class NotificationsCalculator {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final String userId;

  NotificationsCalculator() : userId = FirebaseAuth.instance.currentUser!.uid;

  Future<SystemDetails?> _fetchSystemDetails() async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref("systemDetailsInformation/$userId");
    DataSnapshot snapshot = await dbRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      return SystemDetails.fromMap(data);
    } else {
      print("No data available for user $userId");
      return null;
    }
  }

  Future<List<String>> calculateNotifications() async {
    List<String> notifications = [];

    try {
      
      SystemDetails? systemDetails = await _fetchSystemDetails();
      if (systemDetails == null) {
        notifications.add("System details not found for user $userId");
        return notifications;
      }

  
      List<Map<String, dynamic>> finalOutput = await _calculateFinalOutput(systemDetails);

      int apiHour = int.parse(finalOutput[0]['hour'].split(':')[0]);      
      List<double> consumptionPerMinute = await DeviceConsumption().calculateMinuteConsumption(apiHour);

      List<List<int>> loadShedding = await FetchTodaysLoadSheddingSchedule().getCurrentDayLoadShedding();
      


      // scale loadshedding to our prediction window of the 12 hours from the api
          List<List<int>> adjusted =[];
          int startMinutes = apiHour*60;
          if(loadShedding.length >= 1){
            for(int i = 0; i < loadShedding.length; i++){
            int start = loadShedding[i][0];
            int end = loadShedding[i][1];

            if(start < end){
              adjusted.add([start - startMinutes,end-startMinutes]);
            }else{
              adjusted.add([start - startMinutes,end+1440-startMinutes]); //next day
            }

          }
          }

      // logic that works out notifications

      // loop through to see if we have exceeded max inverter consumption

      //function to format time 

      String formatTime(int hour, int minutes) {
        String formattedHour = hour.toString().padLeft(2, '0');
        String formattedMinutes = minutes.toString().padLeft(2, '0');
        return "$formattedHour:$formattedMinutes";
      }

      for (int i = 0; i < consumptionPerMinute.length; i++) {
        if (consumptionPerMinute[i] > systemDetails.maxInverterCapacity) {
          String time = formatTime(apiHour,(i%60));
          notifications.add("Warning! : Consumption at time $time exceeds your max inverter capacity of ${systemDetails.maxInverterCapacity} (kW)");
          break;
        }
      }

      // loop through final Output calculation and check if it falls in loadshedding times
      List<double> finalOutputKw = getFinalOutput(finalOutput);

      
     int a = 0;
          
          while(a <= adjusted.length-1) { // for each period of loadshedding 
              int start = adjusted[a][0];
              int end = adjusted[a][1];
              int startHour = start ~/60 + (apiHour);
              int startMinutes = (start + (apiHour*60))%60;
              int endHour = end ~/60 + (apiHour);
              int endMinutes = (end + (apiHour*60))%60;
              String startTime = formatTime(startHour, startMinutes);
              String endTime = formatTime(endHour, endMinutes);
              int adjustedStart = 0;
              if((start >= 0)){ // loadhedding schedule falls completly in prediction window
                adjustedStart = start;
              }else if( start < 0 && end >=0){ // psrt of the loadshedding schedule is in our prediction window
                adjustedStart = 0;
              }else if( start < 0 && end <0){ // loadshedding not in prediction window
                  a++;
                  continue;
              }
                  for(int s = adjustedStart ; s < end; s++){ //loop through the minutes of that loadshedding period 
                      if(finalOutputKw[s] < 0 ){
                        notifications.add('Warning! : You will be using grid power during the load shedding period from $startTime - $endTime');
                        break; //only warn once for this interval
                      }
                      }
                  
                  a++; 
        }
        

    } catch (e) {
      notifications.add("Error occurred: $e");
    }

    return notifications;
  }

  List<double> getFinalOutput(List<Map<String, dynamic>> finalOutput) {
    List<double> data = [];

    for (int i = 0; i < finalOutput.length; i++) {
      List<double> outputKwForHour = finalOutput[i]['outputKw'];

      for (int j = 0; j < outputKwForHour.length; j++) {
        data.add(outputKwForHour[j]);
      }
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> _calculateFinalOutput(
      SystemDetails systemDetails) async {
    FinalOutputCalculation finalCalculation = FinalOutputCalculation(
      batterySize: systemDetails.batteryCapacity,
      lowestBatteryPercentage: systemDetails.lowestBatteryPercentage,
      maxPower: systemDetails.maxPowerOutput,
      userID: userId,
      firestore: firestore,
    );

    return await finalCalculation.calculateFinalOutput();
  }
}
