import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/appartment_details/data/model/create_chat_success.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/appartment_details/data/model/remove_favorite_model.dart';

class ApartmentRepo {
  final ApiConsumer apiConsumer;
  ApartmentRepo({required this.apiConsumer});
  Future<Either<Failure, FavoriteModel>> addToFavoirte(
      {required int apartmentId}) async {
    try {
      final response = await apiConsumer
          .post('${ApiConstants.addOrRemoveFavoirte}$apartmentId');
      if (response.statusCode == 200) {
        return Right(FavoriteModel.fromJson(response.data));
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

  Future<Either<Failure, RemoveFavoriteModel>> removeFavorite(
      {required int apartmentId}) async {
    try {
      final response = await apiConsumer
          .post(ApiConstants.addOrRemoveFavoirte + apartmentId.toString());
      if (response.statusCode == 200) {
        return Right(RemoveFavoriteModel.fromJson(response.data));
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

  Future<Either<Failure, CreateChatSuccessful>> createChat(
      {required int apartmentId}) async {
    try {
      final response = await apiConsumer.post(ApiConstants.chats,
          body: FormData.fromMap({"apartment_id": apartmentId}));
      if (response.statusCode == 200) {
        return Right(CreateChatSuccessful.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      else{
        return Left(ServerFailure('An unknown error: $e'));
      }
    }
  }
}
