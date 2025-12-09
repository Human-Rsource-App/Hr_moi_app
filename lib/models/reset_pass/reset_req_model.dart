class ResetReqModel
{
    bool? success;
    String? msg;
    DataModel? data;
    ResetReqModel.fromJson(Map<String, dynamic> json)
    {
        success = json['success'];
        msg = json['msg'];
        data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
    }
}

class DataModel
{
    String? empCode;
    String? phone;
    DataModel.fromJson(Map<String, dynamic> json)
    {
        empCode = json['empCode'];
        phone = json['phone'];

    }
}
