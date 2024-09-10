import 'package:dartz/dartz.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';

class FavoriteRepo {
  final ApiConsumer apiConsumer;
  FavoriteRepo({required this.apiConsumer});
  Future<Either<Failure, FavoriteModel>> getFavoriteData({int page = 1}) async {
    try {
      final response = await apiConsumer.get(ApiConstants.showFavorite,queryParameters: {"page":page});
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
}
