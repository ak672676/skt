import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleDocument {
  String? uid;
  String? title;
  String? type;
  DateTime? addedOn;
  String? url;

  VehicleDocument({this.uid, this.title, this.type, this.addedOn, this.url});

  VehicleDocument.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    title = json['title'];
    type = json['type'];
    addedOn = (json["addedOn"] as Timestamp).toDate();
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['title'] = this.title;
    data['type'] = this.type;
    data['addedOn'] = this.addedOn;
    data['url'] = this.url;
    return data;
  }
}
