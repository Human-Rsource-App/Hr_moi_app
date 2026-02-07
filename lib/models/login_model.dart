class LoginModel
{
    bool? success;
    String? msg;
    DataModel? data;
    String ?err;
    LoginModel.fromJson(Map<String, dynamic> json)
    {
        success = json['success'];
        msg = json['msg'];
        data=json['data']!=null?DataModel.fromJson(json['data']):null;
        err=json['err'];
    }
}
class DataModel
{
    String? token;
    String? empcode;
    DataModel.fromJson(Map<String, dynamic> json){
      token=json['token'];
      token=json['empcode'];
    }
}
