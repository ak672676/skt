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

  Tax(
      {this.uid,
      this.vid,
      this.startDate,
      this.endDate,
      this.taxAmount,
      this.gainAmount,
      this.description,
      this.onDate});

  Tax.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    vid = json['vid'];
    startDate = (json["startDate"] as Timestamp).toDate();
    endDate = (json["endDate"] as Timestamp).toDate();
    taxAmount = json['taxAmount'];
    gainAmount = json['gainAmount'];
    description = json['description'];
    onDate = (json["onDate"] as Timestamp).toDate();
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
    return data;
  }
}
