abstract class SendEmailStates {}

class SendEmailInitialState extends SendEmailStates {}

class SendEmailLoadingState extends SendEmailStates {}

class SendEmailNetworkErrorState extends SendEmailStates {}

class SendEmailSuccessState extends SendEmailStates {}

class SendEmailFailureState extends SendEmailStates {
  final String msg;

  SendEmailFailureState({required this.msg});
}

class FillEmailState extends SendEmailStates {}
