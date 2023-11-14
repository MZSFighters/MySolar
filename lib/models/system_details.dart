class SystemDetails {
  final double maxPowerOutput;
  final double batteryCapacity;
  final double lowestBatteryPercentage;
  final double maxInverterCapacity;

  SystemDetails({
    required this.maxPowerOutput,
    required this.batteryCapacity,
    required this.lowestBatteryPercentage,
    required this.maxInverterCapacity,
  });

factory SystemDetails.fromMap(Map<String, dynamic> data) {
  return SystemDetails(
    maxPowerOutput: (data['maxPowerOutput'] as num).toDouble(),
    batteryCapacity: (data['batteryCapacity'] as num).toDouble(),
    lowestBatteryPercentage: (data['lowestBatteryPercentage'] as num).toDouble(),
    maxInverterCapacity: (data['maxInverterCapacity'] as num).toDouble(),
  );
}

}
