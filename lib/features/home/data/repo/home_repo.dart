import 'package:dartz/dartz.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/home/data/model/home_success_model.dart';

class HomeRepo {
  final ApiConsumer apiConsumer;
  HomeRepo({required this.apiConsumer});
  Future<Either<Failure, HomeSuccessModel>> getHomeData() async {
    try {
      final response = await apiConsumer.get(ApiConstants.showHome);
      if (response.statusCode == 200) {
        return Right(HomeSuccessModel.fromJson(response.data));
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
