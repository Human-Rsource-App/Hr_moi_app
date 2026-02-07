class HrModel
{
    bool? success;
    MsgModel? msg;
    DataModel? data;
    String? err;
    HrModel.fromJson(Map<String, dynamic> json)
    {
        success = json['success'];
        msg = json['msg'] != null ? MsgModel.fromJson(json['msg']) : null;
        data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
        err = json['err'];
    }
}
class MsgModel
{
    String? action;
    int? actionOpr;
    MsgModel.fromJson(Map<String, dynamic> json)
    {
        action = json['action'];
        actionOpr = json['actionOpr'];

    }
}
class DataModel
{
    String? phoneNo;
    String? empCode;
    DataModel.fromJson(Map<String, dynamic> json)
    {
        phoneNo = json['PhoneNo'];
        empCode = json['empCode'];
    }
}
