import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skt/model/vehicle.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addNewVehicle(Vehicle vehicle) async {
    String res = "Some error occoured";
    // vehicle.remove("uid");
    print("addNewVehicle");
    String vehicleId = const Uuid().v1();
    print(vehicle.toJson());
    try {
      await _firestore.collection("vehicles").doc(vehicleId).set({
        'uid': vehicleId,
        'vehicleNumber': vehicle.vehicleNumber,
        'vehicleType': vehicle.vehicleType,
        'ownerName': vehicle.ownerName,
        'ownerContact': vehicle.ownerContact,
        'addedOn': DateTime.now(),
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
