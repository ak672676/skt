import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String? uid;
  String? vehicleNumber;
  String? vehicleType;
  String? ownerName;
  String? ownerContact;
  DateTime? addedOn;
  List<Insurance>? insurance;
  List<Documents>? documents;

  Vehicle(
      {this.uid,
      this.vehicleNumber,
      this.vehicleType,
      this.ownerName,
      this.ownerContact,
      this.addedOn,
      this.insurance,
      this.documents});

  Vehicle.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    vehicleNumber = json['vehicleNumber'];
    vehicleType = json['vehicleType'];
    ownerName = json['ownerName'];
    ownerContact = json['ownerContact'];
    addedOn = (json["addedOn"] as Timestamp).toDate();
    if (json['insurance'] != null) {
      insurance = <Insurance>[];
      json['insurance'].forEach((v) {
        insurance!.add(new Insurance.fromJson(v));
      });
    }
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(new Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['vehicleNumber'] = this.vehicleNumber;
    data['vehicleType'] = this.vehicleType;
    data['ownerName'] = this.ownerName;
    data['ownerContact'] = this.ownerContact;
    data['addedOn'] = this.addedOn;
    if (this.insurance != null) {
      data['insurance'] = this.insurance!.map((v) => v.toJson()).toList();
    }
    if (this.documents != null) {
      data['documents'] = this.documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Insurance {
  DateTime? startDate;
  int? durationInMonths;
  bool? archived;

  Insurance({this.startDate, this.durationInMonths, this.archived});

  Insurance.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    durationInMonths = json['durationInMonths'];
    archived = json['archived'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['durationInMonths'] = this.durationInMonths;
    data['archived'] = this.archived;
    return data;
  }
}

class Documents {
  String? type;
  String? url;
  String? title;

  Documents({this.type, this.url, this.title});

  Documents.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    data['title'] = this.title;
    return data;
  }
}
