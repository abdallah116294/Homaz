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
import 'package:homez/features/otp/view.dart';

import 'cubit.dart';
import 'states.dart';

class SendEmailView extends StatelessWidget {
  const SendEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendEmailCubit(),
      child: const _SendEmailBody(),
    );
  }
}

class _SendEmailBody extends StatelessWidget {
  const _SendEmailBody();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<SendEmailCubit>(context);

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
                const _HeaderSection(),
                SizedBox(height: 0.073.sh),
                _EmailField(cubit: cubit),
                SizedBox(height: 0.2.sh),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _SendEmailButton(cubit: cubit),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Forgot Password?",
          color: ColorManager.white,
          fontSize: 30.sp,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 0.0147.sh),
        CustomText(
          text: "Don’t worry! It’s happens. Please enter the email address.",
          color: ColorManager.grey1,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          maxLines: 5,
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.cubit});

  final SendEmailCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendEmailCubit, SendEmailStates>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Email",
              color: ColorManager.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: cubit.emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Padding(
                padding: EdgeInsets.all(0.0197.sh),
                child: SvgIcon(
                  icon: AssetsStrings.email,
                  height: 0.029.sh,
                  color: ColorManager.white,
                ),
              ),
              hint: "Email..",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter Your Email !";
                }
                return null;
              },
              onChanged: (value) {
                cubit.fillEmail();
              },
              isLastInput: true,
            ),
          ],
        );
      },
    );
  }
}

class _SendEmailButton extends StatelessWidget {
  const _SendEmailButton({required this.cubit});

  final SendEmailCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: Padding(
        padding:
            EdgeInsets.only(right: 0.041.sw, left: 0.041.sw, bottom: 0.03.sh),
        child: BlocConsumer<SendEmailCubit, SendEmailStates>(
          listener: (context, state) {
            if (state is SendEmailFailureState) {
              showMessage(
                message: state.msg,
                color: ColorManager.red,
              );
            } else if (state is SendEmailNetworkErrorState) {
              showMessage(
                message: "check_network",
                color: ColorManager.red,
              );
            } else if (state is SendEmailSuccessState) {
              MagicRouter.navigateTo(
                page: OtpScreen(
                  email: cubit.emailController.text,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is SendEmailLoadingState) {
              return Container(
                height: 0.0689.sh,
                color: Theme.of(context).highlightColor,
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.mainColor,
                  ),
                ),
              );
            }
            return CustomElevated(
              text: "Continue",
              press: () {
                // cubit.sendEmail();
                MagicRouter.navigateTo(
                  page: OtpView(
                    email: cubit.emailController.text,
                  ),
                );
              },
              btnColor: ColorManager.mainColor,
            );
          },
        ),
      ),
    );
  }
}
