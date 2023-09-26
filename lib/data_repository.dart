import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/device.dart';

class DataRepository {
  static final CollectionReference collection =
      FirebaseFirestore.instance.collection('appliances');

  // return a Stream of devices in appliances
  static Stream<QuerySnapshot> getStream() {
    return collection.where("name", isEqualTo: "CA").snapshots();
  }

  //add device to database
  Future<DocumentReference> addDevice(Device device) {
    return collection.add(device.toJson(device));
  }

  // update device in database
  void updateDevice(Device device) async {
    await collection.doc(device.id).update(device.toJson(device));
  }

  //delete device from databases
  void deleteDevice(Device device) async {
    await collection.doc(device.id).delete();
  }
}
