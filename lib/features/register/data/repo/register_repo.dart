import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/register/controller.dart';
import 'package:homez/features/register/data/model/register_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterRepo {
  final ApiConsumer apiConsumer;
  RegisterRepo({required this.apiConsumer});
  var controllers = RegisterControllers();
  Future<Either<Failure, RegisterUserSuccess>> registerUser({
    required String name,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await apiConsumer.post(ApiConstants.register,
          body: FormData.fromMap({
            "fullname": name,
            "password": password,
            "confirm_password": confirmPassword,
            "phone": phone,
            "terms": '1',
          }),
          header: {
            "Accept": 'application/json',
          });
      if (response.statusCode == 200) {
        return Right(RegisterUserSuccess.fromJson(response.data));
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

  Future<Either<Failure, RegisterUserSuccess>> registerWithGoogle({
    required String fullname,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        log('User canceled the sign-in');
        return Left(ServerFailure("User canceled the sign-in"));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (result.user?.photoURL != null) {
        final response = await http.get(Uri.parse(result.user!.photoURL!));
        if (response.statusCode != 200) {
          log('Failed to download image');
          return Left(ServerFailure('Failed to download image'));
        }
        final Uint8List imageBytes = response.bodyBytes;
        log(result.user!.phoneNumber.toString());
        final FormData formData = FormData.fromMap({
          'fullname': result.user!.displayName,
          'password': "passwordE@123",
          'confirm_password': "confirmPasswordE@123",
          'phone':"1122335523" ,
          'terms': '1',
          'provider': 'google',
          'provider_id': result.user!.uid,
        });
       // CacheHelper.put(key: 'phone_number', value: result.user!.phoneNumber);

        final apiResponse =
            await apiConsumer.post(ApiConstants.register, body: FormData.fromMap({
          'fullname': result.user!.displayName,
          'password': "passwordE@123",
          'confirm_password': "confirmPasswordE@123",
          'phone':"1122335523" ,
          'terms': '1',
          'provider': 'google',
          'provider_id': result.user!.uid,
        }));

        if (apiResponse.statusCode == 200) {
          log('Handle successful sign-in');
          return Right(RegisterUserSuccess.fromJson(apiResponse.data));
        } else {
          log('Handle sign-in failure: ${apiResponse.data}');
          return Left(ServerFailure(apiResponse.data));
        }
      } else {
        log('No image URL found for user');
        return Left(ServerFailure('No image URL found for user'));
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future convertImage(XFile image) async {
    return MultipartFile.fromFile(image.path,
        filename: image.path.split('/').last);
  }
}
