class NationalIdModel {
  bool? success;
  String? msg;
  String? data;
  String ? err;
  NationalIdModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    data = json['data'];
    err=json['err'];
  }
}


