class CreatePassModel {
  bool? success;
  String? msg;
  CreatePassModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
  }
}
