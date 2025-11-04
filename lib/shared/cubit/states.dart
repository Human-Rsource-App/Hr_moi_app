abstract class HrMoiStates {}

class InitialState extends HrMoiStates {}

//hr number
class HrOtpGetLoadingState extends HrMoiStates {}

class HrOtpGetSuccState extends HrMoiStates {}

class HrOtpGetFailState extends HrMoiStates {}

//otp screen
class OtpGetSuccState extends HrMoiStates {}

class OtpGetFailState extends HrMoiStates {}

//user profile
class HrNumGetLoadingState extends HrMoiStates {}

class HrNumGetSuccState extends HrMoiStates {}

class HrNumGetFailState extends HrMoiStates {}
