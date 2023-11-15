import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

class MyAnalogClock extends StatelessWidget {
  const MyAnalogClock({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.only(
      top: 10 + MediaQuery.of(context).padding.top,
      bottom: 10,
    ),
    child: Center(
      child: AnalogClock(
                decoration: BoxDecoration(
                border: Border.all(width: 2.0 ,color: Colors.black),
                color: Colors.transparent,
                shape: BoxShape.circle),
              width: 150.0,
              isLive: true,
              hourHandColor: Colors.black,
              minuteHandColor: Colors.black,
              showSecondHand: true,
              secondHandColor: Colors.red,
              numberColor: Colors.black87,
              showNumbers: true,
              showAllNumbers: false,
              textScaleFactor: 1.4,
              showTicks: true,
              showDigitalClock: true,
      ),
    ),
  );
}