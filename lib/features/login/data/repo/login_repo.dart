import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/login/data/model/login_model_success.dart';

class LoginRepo {
  final ApiConsumer apiConsumer;
  LoginRepo({required this.apiConsumer});
  Future<Either<Failure, LoginUserSuccess>> loginUser({
    required String phone,
    required String password,
    required String deviceToken,
    required String deviceType,
  }) async {
    try {
      final response = await apiConsumer.post(ApiConstants.login,body: FormData.fromMap({
        "password": password,
        'device_token': deviceToken,
        'type': deviceType,
        "phone": phone,
      }));
      if(response.statusCode == 200){
        return Right(LoginUserSuccess.fromJson(response.data));
      }else{
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
