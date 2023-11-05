import 'solarPowerProduced.dart';
import 'fetchWeatherData.dart';


class FinalOutputCalculation {
  final double batterySize; 
  final int lowestBatteryPercentage; 
  final double maxPower;
  final List<double> consumptionData;

  FinalOutputCalculation({
    required this.batterySize, 
    required this.lowestBatteryPercentage, 
    required this.maxPower,
    required this.consumptionData,
  });

  

  Future<List<Map<String, dynamic>>> calculateFinalOutput() async {
    WeatherService weatherService = WeatherService();
    List<List<dynamic>> weatherData = await weatherService.fetchWeatherData();

    SolarPowerProduced solarPower = SolarPowerProduced(maxOutput: maxPower);
    List<Map<String, dynamic>> solarOutputData = await solarPower.calculateSolarOutput(weatherData);

    List<Map<String, dynamic>> finalOutput = [];

    double possibleStorage = (1 -(lowestBatteryPercentage / 100.0)) * batterySize; // the possible battery storage
    double batteryStorage = 0.00;
    
    
    for (int a = 0; a < 12; a++) { // for each hour

      // SolarPanelOutputForHour is the solar panel system power production in kW.
      double solarPanelOutputForHour = double.parse(solarOutputData[a]['solarOutput'].toStringAsFixed(3)); // 3 decimal places

      /**************************************************************************************/
      // There is the potential here to  add logic that distributes solarPanelOutputForHour (the solar panel production), according to a user's inverter system
      // Some can go to battery storage whilst some can be used directly for consumptionData 
      // We have decided to not implement this logic.
      // Instead, the distribution specified here, is that the battery is filled to its possible storage, and used to feed the house
      // Only, when the battery is full, does solarOutputForHour (the solar panel production) feed the house as well.
      /**************************************************************************************/

      /////// Our Inverter Algorithm //////

      if(batteryStorage < possibleStorage){ //if availabe battery storage
        if(solarPanelOutputForHour < batteryStorage){ 
        batteryStorage += solarPanelOutputForHour; //feed battery first

        solarPanelOutputForHour = solarPanelOutputForHour - batteryStorage; //decrease the solar panel power

        }else{
          batteryStorage = possibleStorage; // this feed will fill up battery storage
        
          solarPanelOutputForHour = solarPanelOutputForHour- batteryStorage; //decrease the solar panel power
        }
      }else{
        batteryStorage = possibleStorage; // else battery is already full, and nothing chages to solarPanelOutputForHour
      }

      List<double> hourlyOutput = [];

      for ( int i = a*60; i < (a+1)*60; i++){ // for each minute in that hour  
        double calculation = double.parse((solarPanelOutputForHour + batteryStorage - consumptionData[i]).toStringAsFixed(3)); 
        hourlyOutput.add(calculation);
        
      }
      
        //print('At Hour : ${solarOutputData[a]['hour']}     :     ${hourlyOutput} \n\n');  // my debug statement
      

    finalOutput.add({
        'hour': solarOutputData[a]['hour'],
        'outputKw': hourlyOutput,
       });
      
    }
    return finalOutput;
  }
}
