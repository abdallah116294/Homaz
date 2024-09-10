import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';

class ForgetPassRepo {
  final ApiConsumer apiConsumer;
  ForgetPassRepo({required this.apiConsumer});
  Future<Either<Failure, dynamic>> forgetPassword(
      {required String phone}) async {
    try {
      final response = await apiConsumer.post(ApiConstants.sendCode,body: FormData.fromMap({
        "phone": phone,
      }));
      if (response.statusCode == 200) {
        return Right(response.data);
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
