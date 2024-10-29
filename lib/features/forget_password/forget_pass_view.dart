import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/custom_text_form_field.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/injection_container.dart' as di;
import 'forget_password_cubit.dart';
import 'forget_password_state.dart';

class ForgetPasswordViews extends StatelessWidget {
  const ForgetPasswordViews({super.key, required this.phone});

  final String? phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ForgetPasswordCubit>(),
      child: ForgetPassBody(
        phone: phone,
      ),
    );
  }
}

class ForgetPassBody extends StatelessWidget {
  const ForgetPassBody({super.key, required this.phone});

  final String? phone;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ForgetPasswordCubit>(context);

    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
        child: SingleChildScrollView(
          child: Column(
            children: [
               CustomAppBarTitle(title: context.translate(LangKeys.forget_password)),
              40.verticalSpace,
              CustomText(
                maxLines: 2,
                text: context.translate(LangKeys.enter_phone_to_reset),
                color: ColorManager.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
              ),
              32.verticalSpace,
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordStates>(
                builder: (context, state) {
                  return _PhoneTextField(cubit: cubit);
                },
              ),
              32.verticalSpace,
              _ForgetPasswordButton(
                cubit: cubit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneTextField extends StatelessWidget {
  const _PhoneTextField({required this.cubit});

  final ForgetPasswordCubit cubit;

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
      hint: context.translate(LangKeys.mobile_number),
      validator: (value) {
        if (value!.isEmpty) {
          return context.translate(LangKeys.enter_mobile_number);
        }
        return null;
      },
    );
  }
}

class _ForgetPasswordButton extends StatelessWidget {
  const _ForgetPasswordButton({required this.cubit});

  final ForgetPasswordCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
      listener: (context, state) {
        if (state is OtpFailureState) {
          showMessage(
            message: state.msg,
            color: ColorManager.red,
          );
        } else if (state is ForgetPasswordNetworkErrorState) {
          showMessage(
            message: "No internet connection",
            color: ColorManager.red,
          );
        } else if (state is OtpSuccessState) {
          log(cubit.controllers.phoneController.text);
          context.pushName(AppRoutes.otpView,arguments: {
            "phone":cubit.controllers.phoneController.text,
            "email":"",
            "navigateFromForget":true,
            "navigateFromProfile":false,
          });
        }
      },
      builder: (context, state) {
        if (state is OtpLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorManager.mainColor,
            ),
          );
        }
        return CustomElevated(
          text: context.translate(LangKeys.send_code),
          press: () {
            cubit.sendCode(phone: cubit.controllers.phoneController.text);
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}
