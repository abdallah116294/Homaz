import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/features/reset_password/view.dart';

import 'components/pinput.dart';
import 'cubit.dart';
import 'states.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit(),
      child: OtpScreen(email: email),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpCubit = context.read<OtpCubit>();
    otpCubit.otpController.clear();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(0.06.sw),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  MagicRouter.navigatePop();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    AssetsStrings.back,
                    height: 30.h,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              CustomText(
                text: "Code validation",
                color: ColorManager.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 20.h),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Please enter the 4 digit code sent to your email : ",
                  style: TextStyle(
                    color: ColorManager.grey1,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: TextStyle(
                        color: ColorManager.mainColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              PinPutWidget(
                controller: otpCubit.otpController,
              ),
              SizedBox(
                height: 0.2.sh,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 1.sw,
        child: Padding(
          padding:
              EdgeInsets.only(right: 0.041.sw, left: 0.041.sw, bottom: 0.03.sh),
          child: BlocConsumer<OtpCubit, OtpStates>(
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
                return SizedBox(
                  height: 0.0689.sh,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.mainColor,
                    ),
                  ),
                );
              }
              return CustomElevated(
                text: "confirm",
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
          ),
        ),
      ),
    );
  }
}
