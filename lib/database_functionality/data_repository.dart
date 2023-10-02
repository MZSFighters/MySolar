import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/device.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:mysolar/models/time.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class DataRepository {
  String? userId;
  CollectionReference collection =
      FirebaseFirestore.instance.collection('appliances');

  DataRepository() {
    User? user = auth.currentUser;
    userId = user!.uid;
    collection = FirebaseFirestore.instance.collection('appliances');

    StreamSubscription sub = getStream().listen((event) {
      Device.devices = event.docs
          .map((e) => Device(
              userId: userId,
              id: e.id,
              name: e['name'],
              time: Time.fromJson(e['time']),
              kw: e['kw']))
          .toList();
    });
  }

  // return a Stream of devices in appliances
  Stream<QuerySnapshot> getStream() {
    return collection.where("userId", isEqualTo: userId).snapshots();
  }

  //add device to database
  Future<DocumentReference> addDevice(Device device) {
    device.userId = userId;
    return collection.add(device.toJson(device));
  }

  // update device in database
  void updateDevice(Device device) async {
    device.userId = userId;
    await collection.doc(device.id).update(device.toJson(device));
  }

  //delete device from databases
  void deleteDevice(Device device) async {
    await collection.doc(device.id).delete();
  }
}
