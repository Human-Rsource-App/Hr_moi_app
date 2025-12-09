import 'package:camera/camera.dart';
import 'package:hr_moi/models/identity_model.dart';

const String baseUrl = 'http://10.21.10.181:3090/api/';
const String userProfUrl = 'moiApp/user_profile/';
const String hrUrl = 'moiApp/search/';
const String otpUrl = 'otpGet/otp/';
const String mrzUrl = 'moiApp/National_id_check/';
const String faceUrl = 'moiApp/ai_reg_img/';
const String regUrl = 'auth/register';
const String loginUrl = 'auth/login';
const String resetPass = 'moiApp/reset_password/request';


//general var
List<CameraDescription>? cameras;
late String nID;
String hrNum='911720011';
late HrProfileModel userProfile;
