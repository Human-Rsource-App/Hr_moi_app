class ResetPassModel {
  bool ? success;
  String? message;
  ResetPassModel.fromJson(Map<String,dynamic>json){
    success=json['success'];
    message=json['message'];
  }
}