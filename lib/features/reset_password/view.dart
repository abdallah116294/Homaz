import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/custom_text_form_field.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/core/widgets/svg_icons.dart';

import 'cubit.dart';
import 'states.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ResetPasswordCubit(),
      child: const _ResetPasswordBody(),
    );
  }
}

class _ResetPasswordBody extends StatelessWidget {
  const _ResetPasswordBody();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ResetPasswordCubit>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(0.06.sw),
        child: Form(
          key: cubit.formKey,
          autovalidateMode: AutovalidateMode.disabled,
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
                  text: "Reset password",
                  color: ColorManager.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 0.0147.sh),
                CustomText(
                  text:
                      "Don’t worry! It’s happens. Please enter your new password.",
                  color: ColorManager.grey1,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  maxLines: 5,
                ),
                SizedBox(height: 30.h),
                CustomText(
                  text: "password",
                  color: ColorManager.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 0.0123.sh,
                ),
                BlocBuilder<ResetPasswordCubit, ResetPasswordStates>(
                  builder: (context, state) {
                    return _PasswordTextField(
                      cubit: cubit,
                    );
                  },
                ),
                SizedBox(
                  height: 0.05.sh,
                ),
                CustomText(
                  text: "confirm password",
                  color: ColorManager.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 0.0123.sh,
                ),
                BlocBuilder<ResetPasswordCubit, ResetPasswordStates>(
                  builder: (context, state) {
                    return _ConfPassTextField(
                      cubit: cubit,
                    );
                  },
                ),
                SizedBox(
                  height: 0.3.sh,
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 1.sw,
        child: Padding(
          padding:
              EdgeInsets.only(right: 0.041.sw, left: 0.041.sw, bottom: 0.03.sh),
          child: _FloatingActionButton(
            cubit: cubit,
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({required this.cubit});

  final ResetPasswordCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.controllers.passwordController,
      prefixIcon: Padding(
        padding: EdgeInsets.all(0.0197.sh),
        child: SvgIcon(
          icon: AssetsStrings.lock,
          height: 0.029.sh,
          color: ColorManager.white,
        ),
      ),
      hint: "password",
      validator: (value) {
        if (value.isEmpty) {
          return "enter_password";
        } else if (value.length < 6) {
          return "enter_6_password";
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
            color: ColorManager.white,
          ),
        ),
      ),
      obscureText: cubit.isObscure,
      interactiveSelection: false,
    );
  }
}

class _ConfPassTextField extends StatelessWidget {
  const _ConfPassTextField({
    required this.cubit,
  });

  final ResetPasswordCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.controllers.confirmPasswordController,
      keyboardType: TextInputType.text,
      prefixIcon: Padding(
        padding: EdgeInsets.all(0.0197.sh),
        child: SvgIcon(
          icon: AssetsStrings.lock,
          height: 0.029.sh,
          color: ColorManager.white,
        ),
      ),
      hint: "confirm password",
      validator: (value) {
        if (value!.isEmpty) {
          return "enter_same_pass";
        } else if (value != cubit.controllers.passwordController.text) {
          return "pass_not_same";
        }
        return null;
      },
      suffixIcon: SizedBox(
        height: 0.02.sh,
        child: IconButton(
          onPressed: () {
            cubit.conChangeVisibility();
          },
          icon: Icon(
            cubit.isConObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: ColorManager.white,
          ),
        ),
      ),
      obscureText: cubit.isConObscure,
      interactiveSelection: false,
      isLastInput: true,
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({
    required this.cubit,
  });

  final ResetPasswordCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordStates>(
      listener: (context, state) {
        if (state is ResetPasswordFailedState) {
          showMessage(
            message: state.msg,
            color: ColorManager.red,
          );
        } else if (state is NetworkErrorState) {
          showMessage(
            message: "check_network",
            color: ColorManager.red,
          );
        } else if (state is ResetPasswordSuccessState) {
          // MagicRouter.navigateTo(
          //   page: const ChangedPasswordSuccessView(),
          //   withHistory: false,
          // );
        }
      },
      builder: (context, state) {
        if (state is ResetPasswordLoadingState) {
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
            // cubit.resetPassword();
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}
