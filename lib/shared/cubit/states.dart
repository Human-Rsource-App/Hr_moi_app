abstract class HrMoiStates {}

class InitialState extends HrMoiStates {}

//hr number
class HrGetLoadingState extends HrMoiStates {}

class HrGetSuccState extends HrMoiStates {}

class HrGetFailState extends HrMoiStates {}

//otp screen
class OtpGetSuccState extends HrMoiStates {}

class OtpGetFailState extends HrMoiStates {}

//Mrz screen
class MrzGetSuccState extends HrMoiStates {}

class MrzGetFailState extends HrMoiStates {}

//face recognition screen
class FaceRecGetSuccState extends HrMoiStates {}

class FaceRecGetFailState extends HrMoiStates {}

//user profile
class HrNumGetLoadingState extends HrMoiStates {}

class HrNumGetSuccState extends HrMoiStates {}

class HrNumGetFailState extends HrMoiStates {}

//create pass
class CreatePassLoadingState extends HrMoiStates {}

class CreatePassSuccState extends HrMoiStates {}

class CreatePassFailState extends HrMoiStates {}

//login states

class LoginLoadingState extends HrMoiStates {}

class LoginSuccState extends HrMoiStates {}

class LoginFailState extends HrMoiStates {}

//reset pass req states
class ResetPassSuccState extends HrMoiStates {}

class ResetPassFailState extends HrMoiStates {}
//otp reset pass
class OtpRestPassSuccState extends HrMoiStates {}

class OtpResetPassFailState extends HrMoiStates {}

//create new pass states
class CreateNewPassSuccState extends HrMoiStates {}

class CreateNewPassFailState extends HrMoiStates {}
