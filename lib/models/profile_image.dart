class ProfileImage {
  bool? success;
  String? message;
  DataModel? data;
  ProfileImage.fromJson(Map<String,dynamic>json){
    success=json['success'];
    message=json['message'];
    data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
  }
}
class DataModel{
  String? mimeType;
  String? imageBase64;
  DataModel.fromJson(Map<String,dynamic>json){
    mimeType=json['mimeType'];
    imageBase64=json['imageBase64'];
  }
}