import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/chat/data/models/chats_model.dart';
import 'package:homez/features/chat/data/models/display_chat.dart';
import 'package:homez/features/chat/data/models/send_message_success.dart';

class ChatRepo {
  final ApiConsumer apiConsumer;
  ChatRepo({required this.apiConsumer});
  Future<Either<Failure, ChatsModel>> getChats() async {
    try {
      final response = await apiConsumer.get(ApiConstants.chats);
      if (response.statusCode == 200) {
        return Right(ChatsModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, SendMessageSuccess>> sendMessage({
    required int chatId,
    required String message,
    List<File>? attachment,
  }) async {
    try {
      FormData formData =
          FormData.fromMap({"chat_id": chatId, "message": message});
      if (attachment != null && attachment.isNotEmpty) {
        for (int i = 0; i < attachment.length; i++) {
          formData.files.add(MapEntry('attachment[$i]', await MultipartFile.fromFile(attachment[i].path,filename: attachment[i].path.split('/').last)));
        }
      }
      final response = await apiConsumer
          .post("${ApiConstants.chats}/$chatId/messages", body: formData);
      if (response.statusCode == 200) {
        return Right(SendMessageSuccess.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure(e.toString()));
      } else {
        return Left(ServerFailure('An unknown error: $e'));
      }
    }
  }

  Future<Either<Failure, DisplayChat>> displayChat({
    required int chatId,
  }) async {
    try {
      final response = await apiConsumer.get("${ApiConstants.chats}/$chatId");
      if (response.statusCode == 200) {
        return Right(DisplayChat.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure(e.toString()));
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }
}
