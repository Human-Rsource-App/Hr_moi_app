class FaceModel {
  bool? success;
  String? msg;
  FaceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
  }
}
