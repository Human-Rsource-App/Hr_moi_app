class HrModel {
  bool? success;
  String? msg;
  DateModel? data;
  HrModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    data = json['data'] != null ? DateModel.fromJson(json['data']) : null;
  }
}

class DateModel {
  String? phoneNo;
  DateModel.fromJson(Map<String, dynamic> json) {
    phoneNo = json['PhoneNo'];
  }
}
