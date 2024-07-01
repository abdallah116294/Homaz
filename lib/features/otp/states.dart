abstract class OtpStates {}

class OtpInitialState extends OtpStates {}

class OtpLoadingState extends OtpStates {}

class OtpSuccessState extends OtpStates {}

class OtpFailureState extends OtpStates {
  final String msg;

  OtpFailureState({required this.msg});
}

class NewPasswordVisibilityState extends OtpStates {}

class NewConfPasswordVisibilityState extends OtpStates {}

class NetworkErrorState extends OtpStates {}
