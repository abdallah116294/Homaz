import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/models/profile_data_model.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/custom_text_form_field.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/profile_details/profile_details_cubit.dart';
import 'package:homez/injection_container.dart' as di;
import 'package:image_picker/image_picker.dart';

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({
    super.key,
    required this.fullName,
    required this.phone,
    required this.userData,
    this.navigateFromProfile = false,
  });

  final String fullName;
  final String phone;
  final bool navigateFromProfile;
  final User userData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ProfileDetailsCubit>(),
      child: ProfileDetailsBody(
        fullName: fullName,
        phone: phone,
        navigateFromProfile: navigateFromProfile,
        userData: userData,
      ),
    );
  }
}

class ProfileDetailsBody extends StatelessWidget {
  const ProfileDetailsBody({
    super.key,
    required this.fullName,
    required this.phone,
    required this.navigateFromProfile,
    required this.userData,
  });

  final String fullName;
  final String phone;
  final bool navigateFromProfile;
  final User userData;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ProfileDetailsCubit>(context);
    cubit.controllers.nameController.text = fullName;
    cubit.controllers.phoneController.text = phone;
    return Scaffold(
      body: Form(
        key: cubit.formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              CustomAppBarTitle(
                title: context.translate(LangKeys.account_details),
                withBack: true,
              ),
              30.verticalSpace,
              BlocBuilder<ProfileDetailsCubit, ProfileDetailsState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Container(
                        height: 100.h,
                        width: 90.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorManager.mainColor,
                            width: 3.w,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.h),
                          child:
                              context.read<ProfileDetailsCubit>().pickedImage !=
                                      null
                                  ? Image(
                                      image: FileImage(
                                        File(context
                                            .read<ProfileDetailsCubit>()
                                            .pickedImage!
                                            .path),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : userData.image != null
                                      ? CachedNetworkImage(
                                          imageUrl: userData.image!)
                                      : SvgPicture.asset(
                                          AssetsStrings.user,
                                          fit: BoxFit.cover,
                                        ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context
                                .read<ProfileDetailsCubit>()
                                .pickImage(ImageSource.gallery);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 5.w),
                            margin: EdgeInsets.only(left: 10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: ColorManager.yellow2,
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgIcon(
                                  icon: AssetsStrings.send,
                                  height: 22,
                                  color: ColorManager.yellow2,
                                ),
                                SizedBox(width: 2.w),
                                CustomText(
                                  text: "Change Profile Picture",
                                  color: ColorManager.yellow2,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              30.verticalSpace,
              _NameTextField(
                cubit: cubit,
              ),
              SizedBox(height: 32.h),
              // CustomElevated(
              //     text:
              //         "Update Phone Number:${cubit.controllers.phoneController.text}",
              //     press: () {
              //       MagicRouter.navigateTo(
              //           page: BlocProvider(
              //         create: (context) => di.sl<ProfileDetailsCubit>(),
              //         child: UpdatePhoneNumber(),
              //       ));
              //     },
              //     btnColor: ColorManager.mainColor),
              _PhoneTextField(
                cubit: cubit.controllers.phoneController.text.isEmpty
                    ? cubit
                    : cubit,
              ),
              // SizedBox(height: 32.h),
              // BlocBuilder<ProfileDetailsCubit, ProfileDetailsState>(
              //   builder: (context, state) {
              //     return _PasswordTextField(cubit: cubit,);
              //   },
              // ),
              SizedBox(height: 32.h),
              _SaverButton(
                phoneNumber: phone,
                cubit: cubit,
                fullName: fullName,
                navigateFromProfile: navigateFromProfile,
                image: context.read<ProfileDetailsCubit>().pickedImage,
              )
            ],
          ),
        ),
      ),
      backgroundColor: ColorManager.bgColor,
    );
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField({required this.cubit});

  final ProfileDetailsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.controllers.nameController,
      prefixIcon: Padding(
        padding: EdgeInsets.all(0.0197.sh),
        child: SvgIcon(
          icon: AssetsStrings.user,
          height: 0.029.sh,
          color: ColorManager.grey10,
        ),
      ),
      hint: "Name",
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Your Name !";
        }
        return null;
      },
    );
  }
}

class _PhoneTextField extends StatelessWidget {
  const _PhoneTextField({required this.cubit});

  final ProfileDetailsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.controllers.phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      prefixIcon: Padding(
        padding: EdgeInsets.all(0.0197.sh),
        child: SvgIcon(
          icon: AssetsStrings.phone,
          height: 0.029.sh,
          color: ColorManager.grey10,
        ),
      ),
      hint: "Mobile Number",
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Mobile Number !";
        }
        return null;
      },
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({required this.cubit});

  final ProfileDetailsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.controllers.passwordController,
      keyboardType: TextInputType.text,
      prefixIcon: Padding(
        padding: EdgeInsets.all(0.0197.sh),
        child: SvgIcon(
          icon: AssetsStrings.lock,
          height: 0.029.sh,
          color: ColorManager.grey10,
        ),
      ),
      hint: "Password",
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your Password";
        } else if (value.length < 6) {
          return "Password must not be less than 6 characters!";
        }
        return null;
      },
      suffixIcon: SizedBox(
        height: 0.02.sh,
        child: GestureDetector(
          onTap: () {
            cubit.changeVisibility();
          },
          child: Icon(
            cubit.isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: ColorManager.grey10,
          ),
        ),
      ),
      obscureText: cubit.isObscure,
      interactiveSelection: false,
      isLastInput: true,
    );
  }
}

class _SaverButton extends StatelessWidget {
  const _SaverButton(
      {required this.cubit,
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
          context.pushName(AppRoutes.otpView,arguments: {
            "phone":cubit.controllers.phoneController.text,
            "navigateFromProfile":true,
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
            }else{
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
