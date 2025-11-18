class HrProfileModel {
  bool? success;
  String? message;
  String? error;
  UserData? data;
  HrProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
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
  }
}
