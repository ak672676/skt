import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skt/model/vehicle.dart';
import 'package:skt/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> addNewVehicle(Vehicle vehicle) async {
    String res = "Some error occoured";

    String vehicleId = const Uuid().v1();

    try {
      await _firestore.collection("vehicles").doc(vehicleId).set({
        'uid': vehicleId,
        'vehicleNumber': vehicle.vehicleNumber,
        'vehicleType': vehicle.vehicleType,
        'ownerName': vehicle.ownerName,
        'ownerContact': vehicle.ownerContact,
        'gvw': vehicle.gvw,
        'engineNumber': vehicle.engineNumber,
        'chassisNumber': vehicle.chassisNumber,
        'addedOn': DateTime.now().millisecondsSinceEpoch,
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> updateVehicle(Vehicle vehicle) async {
    String res = "Some error occoured";

    try {
      await _firestore.collection("vehicles").doc(vehicle.uid).update({
        'vehicleNumber': vehicle.vehicleNumber,
        'vehicleType': vehicle.vehicleType,
        'ownerName': vehicle.ownerName,
        'ownerContact': vehicle.ownerContact,
        'gvw': vehicle.gvw,
        'engineNumber': vehicle.engineNumber,
        'chassisNumber': vehicle.chassisNumber,
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> deleteVehicle(
    String vid,
  ) async {
    String res = "Some error occoured";
    try {
      await _firestore.collection("vehicles").doc(vid).delete();
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> addNewDocument(String uid, String fileDescription,
      String fileName, String fileType, File file) async {
    String res = "Some error occoured";
    try {
      String url =
          await StorageMethod().uploadImageToStorage(fileName, fileType, file);

      if (url == "Error") {
        res = "Error";
        return res;
      }

      String docId = const Uuid().v1();
      await _firestore
          .collection("vehicles")
          .doc(uid)
          .collection("documents")
          .doc(docId)
          .set({
        'uid': docId,
        'title': fileDescription,
        'type': fileType,
        'url': url,
        'addedOn': DateTime.now().millisecondsSinceEpoch,
      });
      res = "success";
    } catch (e) {
      res = "Error";
    }

    return res;
  }

  Future<String> addTax(
      String vid,
      String vehicleNumber,
      String taxAmount,
      String gainAmount,
      String description,
      DateTime startDate,
      DateTime endDate,
      bool isActive) async {
    String res = "Some error occoured";

    String taxId = const Uuid().v1();

    try {
      await _firestore.collection("taxes").doc(taxId).set({
        'uid': taxId,
        'vid': vid,
        'vehicleNumber': vehicleNumber,
        'startDate': startDate.millisecondsSinceEpoch,
        'endDate': endDate.millisecondsSinceEpoch,
        'taxAmount': taxAmount,
        'gainAmount': gainAmount,
        'description': description,
        'onDate': DateTime.now().millisecondsSinceEpoch,
        'isActive': isActive,
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateTax(
      String uid,
      String vid,
      String taxAmount,
      String gainAmount,
      String description,
      DateTime startDate,
      DateTime endDate,
      bool isActive) async {
    String res = "Some error occoured";

    try {
      await _firestore.collection("taxes").doc(uid).update({
        'uid': uid,
        'vid': vid,
        'startDate': startDate.millisecondsSinceEpoch,
        'endDate': endDate.millisecondsSinceEpoch,
        'taxAmount': taxAmount,
        'gainAmount': gainAmount,
        'description': description,
        'isActive': isActive,
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deleteDocument(
    String did,
    String vid,
    String url,
  ) async {
    String res = "Some error occoured";
    try {
      await _storage.refFromURL(url).delete();

      await _firestore
          .collection("vehicles")
          .doc(vid)
          .collection("documents")
          .doc(did)
          .delete();

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deleteTax(
    String tid,
  ) async {
    String res = "Some error occoured";
    try {
      await _firestore.collection("taxes").doc(tid).delete();
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> addInsurance(
      String vid,
      String vehicleNumber,
      String insuranceAmount,
      String gainAmount,
      String valuation,
      String description,
      DateTime startDate,
      DateTime endDate,
      bool isActive) async {
    String res = "Some error occoured";

    String taxId = const Uuid().v1();

    try {
      await _firestore.collection("insurances").doc(taxId).set({
        'uid': taxId,
        'vid': vid,
        'vehicleNumber': vehicleNumber,
        'startDate': startDate.millisecondsSinceEpoch,
        'endDate': endDate.millisecondsSinceEpoch,
        'insuranceAmount': insuranceAmount,
        'valuation': valuation,
        'gainAmount': gainAmount,
        'description': description,
        'onDate': DateTime.now().millisecondsSinceEpoch,
        'isActive': isActive,
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateInsurance(
      String uid,
      String vid,
      String insuranceAmount,
      String gainAmount,
      String valuation,
      String description,
      DateTime startDate,
      DateTime endDate,
      bool isActive) async {
    String res = "Some error occoured";

    try {
      await _firestore.collection("insurances").doc(uid).update({
        'uid': uid,
        'vid': vid,
        'startDate': startDate.millisecondsSinceEpoch,
        'endDate': endDate.millisecondsSinceEpoch,
        'valuation': valuation,
        'insuranceAmount': insuranceAmount,
        'gainAmount': gainAmount,
        'description': description,
        'isActive': isActive,
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deleteInsurance(
    String iid,
  ) async {
    String res = "Some error occoured";
    try {
      await _firestore.collection("insurances").doc(iid).delete();
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
