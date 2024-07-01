import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/features/reset_password/view.dart';

import 'components/pinput.dart';
import 'cubit.dart';
import 'states.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit(),
      child: _OtpBody(phone: phone),
    );
  }
}

class _OtpBody extends StatelessWidget {
  const _OtpBody({
    required this.phone,
  });

  final String phone;

  @override
  Widget build(BuildContext context) {
    final otpCubit = context.read<OtpCubit>();
    otpCubit.otpController.clear();

    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBarTitle(title: "Verification Code"),
              SizedBox(height: 16.h),
              CustomText(
                text: "Enter the Verification Code.",
                color: ColorManager.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                maxLines: 3,
              ),
              CustomText(
                text: "We have sent a verification code to your email.",
                color: ColorManager.grey10,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                maxLines: 3,
              ),
              PinPutWidget(
                controller: otpCubit.otpController,
              ),
              _VerifyOtpButton(otpCubit: otpCubit),
              SizedBox(height: 0.04.sh),
              const _ResendLineWidget(),
              SizedBox(height: 0.2.sh),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerifyOtpButton extends StatelessWidget {
  const _VerifyOtpButton({required this.otpCubit});

  final OtpCubit otpCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpStates>(
      listener: (context, state) {
        if (state is OtpFailureState) {
          showMessage(
            message: state.msg,
            color: ColorManager.red,
          );
        } else if (state is OtpSuccessState) {
          MagicRouter.navigateReplacement(
            page: const ResetPasswordView(),
          );
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
          text: "Continue",
          press: () {
            if (otpCubit.otpController.text.length != 4) {
              showMessage(
                message: "please enter code",
                color: ColorManager.red,
              );
            } else {
              // otpCubit.verifyOtp(
              //   phone: widget.email,
              // );
              MagicRouter.navigateReplacement(
                page: const ResetPasswordView(),
              );
            }
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}

class _ResendLineWidget extends StatelessWidget {
  const _ResendLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "If you didn’t receive the code?  ",
          style: TextStyle(
            color: ColorManager.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: "Resend",
              style: TextStyle(
                color: ColorManager.mainColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  debugPrint("resend");
                },
            ),
          ],
        ),
      ),
    );
  }
}
