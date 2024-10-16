import 'package:homez/features/otp/data/model/check_code_success.dart';
import 'package:homez/features/otp/data/model/confirm_code_succes.dart';

abstract class OtpStates {}

class OtpInitialState extends OtpStates {}

class OtpLoadingState extends OtpStates {}

class OtpSuccessState extends OtpStates {
  final ConfirmeCodeSuccess confirmeCodeSuccess;
  OtpSuccessState({required this.confirmeCodeSuccess});
}

class OtpFailureState extends OtpStates {
  final String msg;

  OtpFailureState({required this.msg});
}

class NewPasswordVisibilityState extends OtpStates {}

class NewConfPasswordVisibilityState extends OtpStates {}

class NetworkErrorState extends OtpStates {}

class ReSendCodeLoadingState extends OtpStates {}

class ReSendCodeFailedState extends OtpStates {
  final String msg;

  ReSendCodeFailedState({required this.msg});
}

class ReSendCodeSuccessState extends OtpStates {
  final String msg;

  ReSendCodeSuccessState({required this.msg});
}

class CheckCodeSuccessState extends OtpStates {
  final CheckCodeSuccess checkCode;
  CheckCodeSuccessState({required this.checkCode});
}

class CheckCodedFailedState extends OtpStates {
  final String msg;
  CheckCodedFailedState({required this.msg});
}
class CheckCodeIsLoading extends OtpStates{}