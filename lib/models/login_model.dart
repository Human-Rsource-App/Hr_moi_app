class LoginModel {
  bool? success;
  String? msg;
  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
  }
}
