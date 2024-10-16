import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/otp/data/model/check_code_success.dart';
import 'package:homez/features/otp/data/model/confirm_code_succes.dart';

class OTPRepo {
  final ApiConsumer apiConsumer;
  OTPRepo({required this.apiConsumer});
  Future<Either<Failure, ConfirmeCodeSuccess>> confirmCode(
      {String? phoneNumber, String? email}) async {
    try {
      if (phoneNumber != null) {
        final response = await apiConsumer.post(ApiConstants.sendOtp,
            body: FormData.fromMap({
              "phone": phoneNumber,
              "otp": "1111",
              'type': 'ios',
              'device_token': 'ssssssssssss'
            }));
        if (response.statusCode == 200) {
          return Right(ConfirmeCodeSuccess.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data));
        }
      } else {
        final response = await apiConsumer.post(ApiConstants.sendOtp,
            body: FormData.fromMap({
              "email": email,
              "otp": "1111",
              'type': 'ios',
              'device_token': 'ssssssssssss'
            }));
        if (response.statusCode == 200) {
          return Right(ConfirmeCodeSuccess.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data));
        }
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, ConfirmeCodeSuccess>> updatePhone(
      {required String phone}) async {
    try {
      final response = await apiConsumer.post(ApiConstants.updatePhone,
          body: FormData.fromMap({
            "phone": phone,
            "otp": "1111",
          }));
      if (response.statusCode == 200) {
        return Right(ConfirmeCodeSuccess.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      } else {
        return Left(ServerFailure('An unknown error: $e'));
      }
    }
  }

  Future<Either<Failure, CheckCodeSuccess>> checkCode(
      {required String phone, required String otp}) async {
    try {
      final response = await apiConsumer.post(ApiConstants.checkCode,
          body: FormData.fromMap({
            "phone": phone,
            "otp": "1111",
          }));
      if (response.statusCode == 200) {
        return Right(CheckCodeSuccess.fromJson(response.data));
      } else {
        return Left(
            ServerFailure.fromResponse(response.statusCode!, response.data));
      }
    } catch (e) {
      if(e is  DioException){
        return Left(ServerFailure.fromResponse(422, e.response!.data));
      }else{
         return Left(ServerFailure('An unknown error: ${e.toString()}'));
      }
    }
  }
}
