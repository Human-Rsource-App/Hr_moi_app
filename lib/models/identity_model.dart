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
  String? unit1;
  String? unit2;
  String? unit3;
  String? unit4;

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
    unit1 = json['unit1'];
    unit2 = json['unit2'];
    unit3 = json['unit3'];
    unit4 = json['unit4'];

  }
}
