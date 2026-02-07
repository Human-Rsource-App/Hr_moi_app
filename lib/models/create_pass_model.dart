class CreatePassModel
{
    bool? success;
    String? msg;
    String? err;
    CreatePassModel.fromJson(Map<String, dynamic> json)
    {
        success = json['success'];
        msg = json['msg'];
        err = json['err'];
    }
}
