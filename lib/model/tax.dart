import 'package:cloud_firestore/cloud_firestore.dart';

class Tax {
  String? uid;
  String? vid;
  DateTime? startDate;
  DateTime? endDate;
  String? taxAmount;
  String? gainAmount;
  String? description;
  DateTime? onDate;
  bool? isActive;

  Tax(
      {this.uid,
      this.vid,
      this.startDate,
      this.endDate,
      this.taxAmount,
      this.gainAmount,
      this.description,
      this.onDate,
      this.isActive});

  Tax.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    vid = json['vid'];
    startDate = DateTime.fromMillisecondsSinceEpoch(json["startDate"]);
    endDate = DateTime.fromMillisecondsSinceEpoch(json["endDate"]);
    taxAmount = json['taxAmount'];
    gainAmount = json['gainAmount'];
    description = json['description'];
    // onDate = (json["onDate"] as Timestamp).toDate();
    // print("Printing datetime: " + json["onDate"].toString());
    onDate = DateTime.fromMillisecondsSinceEpoch(json["onDate"]);
    isActive = json['isActive'];
    // print("Printing datetime: " + onDate.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['vid'] = this.vid;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['taxAmount'] = this.taxAmount;
    data['gainAmount'] = this.gainAmount;
    data['description'] = this.description;
    data['onDate'] = this.onDate;
    data['isActive'] = this.isActive;
    return data;
  }
}
