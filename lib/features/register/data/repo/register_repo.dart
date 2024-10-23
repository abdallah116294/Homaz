import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homez/core/error/failures.dart';
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
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
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
            "type":"normal"
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

// Future<Either<Failure, RegisterUserSuccess>> registerWithGoogle() async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       log('User canceled the sign-in');
//       return Left(ServerFailure("User canceled the sign-in"));
//     }

//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//     AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final result = await FirebaseAuth.instance.signInWithCredential(credential);
//     if (result.user != null) {
//       final String displayName = result.user!.displayName ?? "Unknown User";
//       log("Display Name: $displayName");

//       if (result.user?.photoURL != null) {
//         final response = await http.get(Uri.parse(result.user!.photoURL!));
//         if (response.statusCode != 200) {
//           log('Failed to download image');
//           return Left(ServerFailure('Failed to download image'));
//         }

//         final FormData formData = FormData.fromMap({
//           'fullname': displayName,
//           'terms': "1",
//           'email': result.user!.email,
//           'type': "social",
//           'provider': 'google',
//           'provider_id': result.user!.uid,
//         });

//         final apiResponse = await apiConsumer.post(
//           ApiConstants.register,
//           body: formData,
//         );

//         log('Register with Google response: ${apiResponse.data}');
        
//         if (apiResponse.statusCode == 200) {
//           log('Handle successful sign-in');
//           return Right(RegisterUserSuccess.fromJson(apiResponse.data));
//         } else if (apiResponse.statusCode == 302 || apiResponse.statusCode == 400) {
//           // Handle the specific error message
//           if (apiResponse.data['message'] == "The email has already been taken.") {
//             log('Email already registered error');
//             return Left(ServerFailure(apiResponse.data['message']));
//           } else if (apiResponse.data['errors'] != null && apiResponse.data['errors']['email'] != null) {
//             log('Email error: ${apiResponse.data['errors']['email'][0]}');
//             return Left(ServerFailure(apiResponse.data['errors']['email'][0]));
//           } else {
//             return Left(ServerFailure('Unexpected error during registration.'));
//           }
//         } else {
//           log('Handle sign-in failure: ${apiResponse.data}');
//           return Left(ServerFailure(apiResponse.data));
//         }
//       } else {
//         log('No image URL found for user');
//         return Left(ServerFailure('No image URL found for user'));
//       }
//     } else {
//       log('No user found after sign-in');
//       return Left(ServerFailure('No User Found after sign-in'));
//     }
//   } catch (e) {
//     log('An error occurred: $e');
//     return Left(ServerFailure('An error occurred: $e'));
//   }
// }

  Future<Either<Failure, RegisterUserSuccess>> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
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
      if (result.user != null) {
        final String displayName = result.user!.displayName ?? "UKnow User";
        log("Display Name:$displayName");

        if (result.user?.photoURL != null) {
          final response = await http.get(Uri.parse(result.user!.photoURL!));
          if (response.statusCode != 200) {
            log('Failed to download image');
            return Left(ServerFailure('Failed to download image'));
          }
          final Uint8List imageBytes = response.bodyBytes;
          // log(result.user!.phoneNumber.toString());
          log(result.user!.displayName.toString());
          final FormData formData = FormData.fromMap({
            'fullname': displayName,
            "terms": "1",
            "email":result.user!.email,
           // 'image': imageBytes,
            "type": "social",
            'provider': 'google',
            'provider_id': result.user!.uid,
          });
          final apiResponse =
              await apiConsumer.post(ApiConstants.register, body: formData,);
          log('Register with google response:${apiResponse.data}');
          if (apiResponse.statusCode == 200) {
            log('Handle successful sign-in');
            return Right(RegisterUserSuccess.fromJson(apiResponse.data));
          }else if(apiResponse.statusCode == 302){
          log('Redirect detected, possible error: Email already registered');
          return Left(ServerFailure("The email has already been taken."));
          }
           else {
            log('Handle sign-in failure: ${apiResponse.data}');
            return Left(ServerFailure(apiResponse.data));
          }
        } else {
          log('No image URL found for user');
          return Left(ServerFailure('No image URL found for user'));
        }
      } else {
        log('No user Found');
        return Left(ServerFailure('No User Found after sign-in'));
      }
    } catch (e) {
      if (e is GoogleSignInAccount) {
        return Left(ServerFailure("User canceled the sign-in"));
      } else {
        log('An error occurred: $e');
        return Left(ServerFailure('An error occurred: $e'));
      }
    }
  }

  Future convertImage(XFile image) async {
    return MultipartFile.fromFile(image.path,
        filename: image.path.split('/').last);
  }
}
