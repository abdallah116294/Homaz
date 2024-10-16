import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text_form_field.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/profile_details/profile_details_cubit.dart';

class UpdatePhoneNumber extends StatefulWidget {
  const UpdatePhoneNumber({super.key});

  @override
  State<UpdatePhoneNumber> createState() => _UpdatePhoneNumberState();
}

class _UpdatePhoneNumberState extends State<UpdatePhoneNumber> {
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ProfileDetailsCubit>(context);
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: Form(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            CustomAppBarTitle(
              title: context.translate(LangKeys.account_details),
              withBack: true,
            ),
            30.verticalSpace,
            _PhoneTextField(phoneController: phoneController),
            30.verticalSpace,
            _SaverButton(cubit: cubit, phone: phoneController.text),
          ],
        ),
      )),
    );
  }
}

class _PhoneTextField extends StatelessWidget {
  const _PhoneTextField({required this.phoneController});

  //final ProfileDetailsCubit cubit;
  final TextEditingController phoneController;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: phoneController,
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

class _SaverButton extends StatelessWidget {
  const _SaverButton({
    required this.cubit,
    required this.phone,
  });

  final ProfileDetailsCubit cubit;
  final String phone;
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
          context.pop();
        } else if (state is UpdatePhoneSuccessState) {
          context.pushName(AppRoutes.otpView, arguments: {
            "phone": cubit.controllers.phoneController.text,
            "navigateFromProfile": true,
          });
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
          text: "Save",
          press: () {
            cubit.updatePhone(
              phone: phone,
            );
            // // log(fullName != cubit.controllers.nameController.text
            // //     ? cubit.controllers.nameController.text
            // //     : null.toString());
            // cubit.updateProfile2(
            //   fullName: fullName != cubit.controllers.nameController.text
            //       ? cubit.controllers.nameController.text
            //       : null,
            //   image: cubit.pickedImage ?? null,
            // );
            // // fullName != cubit.controllers.phoneController.text
            // //     ? cubit.updatePhone()
            // //     : cubit.updateProfile();
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}
