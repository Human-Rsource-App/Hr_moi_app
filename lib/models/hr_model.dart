class HrOtpModel {
  bool? success;
  String? message;
  DateModel? data;
  HrOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? DateModel.fromJson(json['data']) : null;
  }
}

class DateModel {
  String? phoneNo;
  DateModel.fromJson(Map<String, dynamic> json) {
    phoneNo = json['PhoneNo'];
  }
}
