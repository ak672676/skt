import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String? uid;
  String? vehicleNumber;
  String? vehicleType;
  String? ownerName;
  String? ownerContact;
  DateTime? addedOn;

  Vehicle({
    this.uid,
    this.vehicleNumber,
    this.vehicleType,
    this.ownerName,
    this.ownerContact,
    this.addedOn,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    vehicleNumber = json['vehicleNumber'];
    vehicleType = json['vehicleType'];
    ownerName = json['ownerName'];
    ownerContact = json['ownerContact'];
    addedOn = DateTime.fromMillisecondsSinceEpoch(json["addedOn"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['vehicleNumber'] = this.vehicleNumber;
    data['vehicleType'] = this.vehicleType;
    data['ownerName'] = this.ownerName;
    data['ownerContact'] = this.ownerContact;
    data['addedOn'] = this.addedOn;

    return data;
  }
}
