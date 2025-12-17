class HrProfileModel {
  bool? success;
  String? msg;
  UserData? data;
  HrProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
}

class UserData {
  String? empCode;
  String? rkTypeName;
  String? empStatusName;
  String? rankName;
  String? jobTitleName;
  String? empName;
  String? jenNatinalNo;
  String? phoneNo;
  String? unitName;
  String? unit_1;
  String? unit_2;
  String? unit_3;
  String? unit_4;
  String? unit_5;
  UserData.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    rkTypeName = json['rkTypeName'];
    empStatusName = json['empStatusName'];
    rankName = json['rankName'];
    jobTitleName = json['jobTitleName'];
    empName = json['empName'];
    jenNatinalNo = json['jenNatinalNo'];
    phoneNo = json['PhoneNo'];
    unitName = json['unitName'];
    unit_1 = json['unit_1'];
    unit_2 = json['unit_2'];
    unit_3 = json['unit_3'];
    unit_4 = json['unit_4'];
    unit_5 = json['unit_5'];
  }
}
