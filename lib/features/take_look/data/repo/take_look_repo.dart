import 'package:dartz/dartz.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/take_look/data/model/take_look_model.dart';

class TakeLookRepo {
  final ApiConsumer apiConsumer;
  TakeLookRepo({required this.apiConsumer});
  Future<Either<Failure, TakeLookData>> takeLookData({required int apartmentId}) async {
    try {
      final response = await apiConsumer.get(ApiConstants.takeLook+apartmentId.toString());
      if (response.statusCode == 200) {
        return Right(TakeLookData.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if(e is ServerFailure){
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }
}
