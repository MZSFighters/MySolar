import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/device.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class DataRepository {
  static final User? user = auth.currentUser;
  static String userId = user!.uid;

  static final CollectionReference collection =
      FirebaseFirestore.instance.collection('appliances');

  // return a Stream of devices in appliances
  static Stream<QuerySnapshot> getStream() {
    return collection
        .where("userId", isEqualTo: DataRepository.userId)
        .snapshots();
  }

  //add device to database
  Future<DocumentReference> addDevice(Device device) {
    device.userId = DataRepository.userId;
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
