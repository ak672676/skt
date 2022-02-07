import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String? uid;
  String? vehicleNumber;
  String? vehicleType;
  String? ownerName;
  String? ownerContact;

  String? chassisNumber;
  String? engineNumber;
  String? gvw;

  DateTime? addedOn;

  Vehicle({
    this.uid,
    this.vehicleNumber,
    this.vehicleType,
    this.ownerName,
    this.ownerContact,
    this.addedOn,
    this.chassisNumber,
    this.engineNumber,
    this.gvw,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    vehicleNumber = json['vehicleNumber'];
    vehicleType = json['vehicleType'];
    ownerName = json['ownerName'];
    ownerContact = json['ownerContact'];
    chassisNumber = json['chassisNumber'];
    engineNumber = json['engineNumber'];
    gvw = json['gvw'];

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
    data['chassisNumber'] = this.chassisNumber;
    data['engineNumber'] = this.engineNumber;
    data['gvw'] = this.gvw;

    return data;
  }
}
