import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/features/profile_details/profile_details_cubit.dart';
import 'package:image_picker/image_picker.dart';

class SaverButton extends StatelessWidget {
  const SaverButton(
      {super.key, required this.cubit,
      required this.fullName,
      required this.navigateFromProfile,
      required this.image,
      required this.phoneNumber});

  final ProfileDetailsCubit cubit;
  final String fullName;
  final bool navigateFromProfile;
  final XFile? image;
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileDetailsCubit, ProfileDetailsState>(
      listener: (context, state) {
        if (state is UpdateProfileFailedState) {
          showMessage(
            message: state.msg,
            color: ColorManager.red,
          );
        } else if (state is UpdateProfileSuccessState) {
          showMessage(
            message: "Profile Updated Successfully",
            color: ColorManager.green,
          );
          cubit.profileInfoData();
          MagicRouter.navigatePop();
        } else if (state is UpdatePhoneSuccessState) {
          context.pushName(AppRoutes.otpView, arguments: {
            "phone": cubit.controllers.phoneController.text,
            "navigateFromProfile": true,
          });
          // MagicRouter.navigateTo(
          //     page: OtpView(
          //   phone: cubit.controllers.phoneController.text,
          //   navigateFromProfile: true,
          // ));
        }
      },
      builder: (context, state) {
        if (state is UpdateProfileLoadingState) {
          return CircularProgressIndicator(
            color: ColorManager.mainColor,
          );
        } else if (state is UpdatePhoneLoadingState) {
          return CircularProgressIndicator(
            color: ColorManager.mainColor,
          );
        }
        return CustomElevated(
          text: context.translate(LangKeys.save),
          press: () {
            String newFullName = cubit.controllers.nameController.text;
            String newPhoneNumber = cubit.controllers.phoneController.text;

            bool isNameChanged = fullName != newFullName;
            bool isPhoneChanged = phoneNumber != newPhoneNumber;
            bool isImageChanged = image != null && cubit.pickedImage != null;

            log(fullName != cubit.controllers.nameController.text
                ? cubit.controllers.nameController.text
                : null.toString());
            //update only phone number
            if (phoneNumber != cubit.controllers.phoneController.text) {
              cubit.updatePhone(phone: newPhoneNumber);
              //Update 3 things
            }
            // else if (phoneNumber != cubit.controllers.phoneController.text &&
            //     image != null &&
            //     fullName != cubit.controllers.nameController.text) {
            //   cubit.updateProfile2(
            //     fullName: fullName != cubit.controllers.nameController.text
            //         ? cubit.controllers.nameController.text
            //         : null,
            //     image: cubit.pickedImage ?? null,
            //   );
            //   cubit.updatePhone(phone: phoneNumber);
            //   //Update 2 things
            // }
            else if (fullName != cubit.controllers.nameController.text &&
                image != null) {
              cubit.updateProfile2(
                fullName: fullName != cubit.controllers.nameController.text
                    ? cubit.controllers.nameController.text
                    : null,
                image: cubit.pickedImage ?? null,
              );
              //default update
            } else {
              cubit.updateProfile2(
                fullName: fullName != cubit.controllers.nameController.text
                    ? cubit.controllers.nameController.text
                    : null,
                image: cubit.pickedImage ?? null,
              );
            }
            // cubit.updateProfile2(
            //   fullName: fullName != cubit.controllers.nameController.text
            //       ? cubit.controllers.nameController.text
            //       : null,
            //   image: cubit.pickedImage ?? null,
            // );
            // fullName != cubit.controllers.phoneController.text
            //     ? cubit.updatePhone()
            //     : cubit.updateProfile();
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}
