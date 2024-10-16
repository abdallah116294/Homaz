import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/models/profile_data_model.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetailsRepo {
  final ApiConsumer apiConsumer;
  ProfileDetailsRepo({required this.apiConsumer});
  Future<Either<Failure, dynamic>> updateProfile(
      {required String fullName}) async {
    try {
      final respnse = await apiConsumer.post(
        ApiConstants.updateProfile,
        body: FormData.fromMap({'fullname': fullName}),
        header: {
          "Accept": "application/json",
        },
      );
      if (respnse.statusCode == 200) {
        return Right(respnse.data);
      } else {
        return Left(ServerFailure(respnse.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, ProfileDataModel>> updateProfile2({
    String? fullName,
    XFile? image,
  }) async {
    try {
      Map<String, dynamic> bodyData = {
        "fullname": fullName,
        "image": image != null ? await convertImage(image) : null,
      };
      bodyData.removeWhere((key, value) => value == null);
      final response = await apiConsumer.post(ApiConstants.updateProfile,
          body: FormData.fromMap(bodyData));
      if (response.statusCode == 200) {
        return Right(ProfileDataModel.fromJson(response.data));
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

  Future<Either<Failure, dynamic>> updatePhone({required String phone}) async {
    try {
      final respnse = await apiConsumer.post(
        ApiConstants.sendOtpToUpdatePhone,
        body: FormData.fromMap({'phone': phone}),
      );
      if (respnse.statusCode == 200) {
        return Right(respnse.data);
      } else {
        return Left(ServerFailure(respnse.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, ProfileDataModel>> profileInfoData() async {
    try {
      final response = await apiConsumer.get(ApiConstants.showProfile);
      if (response.statusCode == 200) {
        return Right(ProfileDataModel.fromJson(response.data));
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

  Future<Either<Failure, ProfileDataModel>> deleteAccount(
      {required String password})async {
    try {
      final response =await apiConsumer.post(ApiConstants.deleteAccount,body: FormData.fromMap({
        "password":password
      }));
      if(response.statusCode==200){
        return Right(ProfileDataModel.fromJson(response.data));
      }else{
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future convertImage(XFile image) async {
    return MultipartFile.fromFile(image.path,
        filename: image.path.split('/').last);
  }
}
