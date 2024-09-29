part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}
class GetChatsLoadingState extends ChatState {}
class GetChatsSuccessState extends ChatState {
  final ChatsModel chatsModel;
  const GetChatsSuccessState(this.chatsModel);
}
class GetChatsErrorState extends ChatState {
  final String error;
  const GetChatsErrorState(this.error);
}
class SendMessageLoadingState extends ChatState {}
class SendMessageSuccessState extends ChatState {
  final SendMessageSuccess sendMessageSuccess;
  const SendMessageSuccessState(this.sendMessageSuccess);
}
class SendMessageErrorState extends ChatState {
  final String error;
  const SendMessageErrorState(this.error);
}
class DisplayChatLoading extends ChatState {}
class DisplayChatSuccessState extends ChatState {
  final DisplayChat displayChat;
  const DisplayChatSuccessState(this.displayChat);
}
class DisplayChatErrorState extends ChatState {
  final String error;
  const DisplayChatErrorState(this.error);
}

