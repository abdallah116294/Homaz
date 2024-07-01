abstract class ResetPasswordStates {}

class ResetPasswordInitialState extends ResetPasswordStates {}

class ResetPasswordLoadingState extends ResetPasswordStates {}

class ResetPasswordSuccessState extends ResetPasswordStates {}

class ResetPasswordFailedState extends ResetPasswordStates {
  final String msg;

  ResetPasswordFailedState({required this.msg});
}

class NetworkErrorState extends ResetPasswordStates {}

class ChangeVisibilityState extends ResetPasswordStates {}

class ConChangeVisibilityState extends ResetPasswordStates {}
