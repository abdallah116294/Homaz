import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/features/chat/data/models/chats_model.dart';
import 'package:homez/features/chat/data/models/display_chat.dart';
import 'package:homez/features/chat/data/models/send_message_success.dart';
import 'package:homez/features/chat/data/repo/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required this.chatRepo}) : super(ChatInitial());
  static ChatCubit get(context) => BlocProvider.of(context);
  ChatRepo chatRepo;
  Future<void> getChats() async {
    emit(GetChatsLoadingState());
    try {
      final response = await chatRepo.getChats();
      response.fold((l) => emit(GetChatsErrorState(l.toString())),
          (r) => emit(GetChatsSuccessState(r)));
    } catch (e) {
      emit(GetChatsErrorState(e.toString()));
    }
  }

  Future<void> sendMessage({
    required String message,
    required int chatId,
    File? attachment,
  }) async {
    emit(SendMessageLoadingState());
    try {
      final response = await chatRepo.sendMessage(
          chatId: chatId, message: message, attachment: attachment);
      response.fold((l) => emit(SendMessageErrorState(l.toString())),
          (r) => emit(SendMessageSuccessState(r)));
    } catch (e) {
      emit(SendMessageErrorState(e.toString()));
    }
  }

  Future<void> displayChat({required int chatId}) async {
    emit(DisplayChatLoading());
    try {
      final response = await chatRepo.displayChat(chatId: chatId);
      response.fold((l) => emit(DisplayChatErrorState(l.toString())),
          (r) => emit(DisplayChatSuccessState(r)));
    } catch (e) {
      emit(DisplayChatErrorState(e.toString()));
    }
  }
}
