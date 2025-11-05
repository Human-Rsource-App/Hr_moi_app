class OtpModel {
  bool? success;
  String? msg;
  DataModel? data;
  OtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
  }
}

class DataModel {
  String? otp;
  DataModel.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
  }
}
