part of 'take_look_cubit.dart';

sealed class TakeLookState extends Equatable {
  const TakeLookState();

  @override
  List<Object> get props => [];
}

final class TakeLookInitial extends TakeLookState {}
class TakeLookLoading extends TakeLookState{}
class TakeLookSuccess extends TakeLookState{
  TakeLookData takeLookData;
  TakeLookSuccess({required this.takeLookData});
}
class TakeLookFailed extends TakeLookState{
  final String msg;
  TakeLookFailed({ required this.msg });
}
class CreateChatLoading extends TakeLookState{}
class CreateChatSuccessTakeLookCubit extends TakeLookState{
  CreateChatSuccessful createChatSuccessful;
  CreateChatSuccessTakeLookCubit({required this.createChatSuccessful});
}
class CreateChatFailed extends TakeLookState{}