import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';

class ResetPasswordRepo {
  final ApiConsumer apiConsumer;
  ResetPasswordRepo({required this.apiConsumer});
  Future<Either<Failure, dynamic>> resetPassword(
      {required String phone, required String otp, required String password, required String confirmPassword}) async {
    try {
      final response = await apiConsumer.post(ApiConstants.resetPassword,body: FormData.fromMap({
        "phone": phone,
        "otp": otp,
        "password": password,
        "confirm_password": confirmPassword,
      }));
      if(response.statusCode == 200){
        return Right(response.data);
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
