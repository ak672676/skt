class Insurance {
  String? uid;
  String? vid;
  String? vehicleNumber;
  DateTime? startDate;
  DateTime? endDate;
  String? insuranceAmount;
  String? gainAmount;
  String? valuation;
  String? description;
  DateTime? onDate;
  bool? isActive;

  Insurance(
      {this.uid,
      this.vid,
      this.vehicleNumber,
      this.startDate,
      this.endDate,
      this.insuranceAmount,
      this.gainAmount,
      this.valuation,
      this.description,
      this.onDate,
      this.isActive});

  Insurance.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    vid = json['vid'];
    vehicleNumber = json['vehicleNumber'];
    startDate = DateTime.fromMillisecondsSinceEpoch(json["startDate"]);
    endDate = DateTime.fromMillisecondsSinceEpoch(json["endDate"]);
    insuranceAmount = json['insuranceAmount'];
    gainAmount = json['gainAmount'];
    valuation = json['valuation'];
    description = json['description'];
    onDate = DateTime.fromMillisecondsSinceEpoch(json["onDate"]);
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['vid'] = this.vid;
    data['vehicleNumber'] = this.vehicleNumber;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['insuranceAmount'] = this.insuranceAmount;
    data['gainAmount'] = this.gainAmount;
    data['valuation'] = this.valuation;
    data['description'] = this.description;
    data['onDate'] = this.onDate;
    data['isActive'] = this.isActive;
    return data;
  }
}
