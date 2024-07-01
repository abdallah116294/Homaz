import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/app_bar.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/custom_text_form_field.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/forget_password/forget_password_cubit.dart';

class ForgetPasswordViews extends StatelessWidget {
  const ForgetPasswordViews({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: ForgetPassBody(),
    );
  }
}

class ForgetPassBody extends StatelessWidget {
  const ForgetPassBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ForgetPasswordCubit>(context);

    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      appBar: CustomAppBar(
          text: 'Forget Password',
          backgroundColor: ColorManager.bgColor,
          leadingColor: ColorManager.white,
          textColor: ColorManager.white),
      body: Padding(
        padding: EdgeInsets.all(0.06.sw),
        child: SingleChildScrollView(
          child: Column(
            children: [
              40.verticalSpace,
              CustomText(
                maxLines: 2,
                  text: 'Enter your Mobile number to reset your password.',
                  color: ColorManager.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp),
              32.verticalSpace,
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordStates>(
                builder: (context, state) {
                  return _PhoneTextField(cubit: cubit);
                },
              ),
              32.verticalSpace,
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordStates>(
                builder: (context, state) {
                  return _ForgetPasswordButton(cubit: cubit);
                },
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

class _ForgetPasswordButton extends StatelessWidget {
  const _ForgetPasswordButton({required this.cubit});

  final ForgetPasswordCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
      listener: (context, state) {
        if (state is ForgetPasswordFailedState) {
          showMessage(
            message: state.msg,
            color: ColorManager.red,
          );
        } else if (state is ErrorNetworkState) {
          showMessage(
            message: "No internet connection",
            color: ColorManager.red,
          );
        } else if (state is ForgetPasswordSuccessState) {
          // MagicRouter.navigateTo(
          //   page: const NavBarView(),
          //   withHistory: false,
          // );
        }
      },
      builder: (context, state) {
        if (state is ForgetPasswordLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorManager.mainColor,
            ),
          );
        }
        return CustomElevated(
          text: "Send Code",
          press: () {
            // cubit.ForgetPassword();
            // MagicRouter.navigateTo(
            //   page: const NavBarView(),
            //   withHistory: false,
            // );
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}
