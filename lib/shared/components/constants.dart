import 'package:camera/camera.dart';
import 'package:hr_moi/models/hr_profile_model.dart';

const String baseUrl = 'http://10.21.10.181:3090/api/';
const String userProfUrl = 'moiApp/user_profile/';
const String hrUrl = 'moiApp/search/';
const String otpUrl = 'otpGet/otp/';

//general var
HrProfileModel? userProfile;
List<CameraDescription>? cameras;
