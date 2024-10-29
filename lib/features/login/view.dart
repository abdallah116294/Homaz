import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/custom_text_form_field.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/app/cubit/app_cubit.dart';
import 'package:homez/injection_container.dart' as di;
import 'components/or_divider.dart';
import 'components/register_line.dart';
import 'cubit.dart';
import 'states.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LoginCubit>(),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LoginCubit>(context);

    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: Form(
        key: cubit.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(0.06.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(100.w, 48.h),
                                backgroundColor: Colors.transparent,
                                side:
                                    const BorderSide(color: Color(0xffEFC3C3))),
                            onPressed: () {
                              context.read<AppCubit>().toggleLanguage();
                            },
                            child: Text(
                          "(${ context.translate(LangKeys.language)})",
                              style: TextStyle(
                                  color:const  Color(0xffEFC3C3), fontSize: 12.sp),
                            )),
                      ),
                    ),
                SizedBox(height: 80.h),
                Padding(
                  padding: EdgeInsets.only(right: 0.2.sw),
                  child: CustomText(
                    text: "${context.translate(LangKeys.welcome_to)} Homz",
                    color: ColorManager.white,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w800,
                    maxLines: 3,
                  ),
                ),
                SizedBox(height: 30.h),
                BlocBuilder<LoginCubit, LoginStates>(
                  builder: (context, state) {
                    return _PhoneTextField(cubit: cubit);
                  },
                ),
                SizedBox(height: 0.03.sh),
                BlocBuilder<LoginCubit, LoginStates>(
                  builder: (context, state) {
                    return _PasswordTextField(cubit: cubit);
                  },
                ),
                SizedBox(height: 0.01.sh),
                Align(
                  alignment:CacheHelper.get(key: "selected_language")=="ar"?Alignment.centerRight:Alignment.centerLeft,
                  child: _ForgetPasswordWidget(
                    cubit: cubit,
                  ),
                ),
                SizedBox(height: 0.03.sh),
                _LoginButton(cubit: cubit),
                SizedBox(height: 0.027.sh),
                const Center(child: RegisterLineWidget()),
                SizedBox(height: 0.027.sh),
                _OrLineWithAuthGoogle(
                  cubit: cubit,
                ),
                SizedBox(height: 0.15.sh),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneTextField extends StatelessWidget {
  const _PhoneTextField({required this.cubit});

  final LoginCubit cubit;

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

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({required this.cubit});

  final LoginCubit cubit;

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
      hint: context.translate(LangKeys.password),
      validator: (value) {
        if (value!.isEmpty) {
          return context.translate(LangKeys.enter_password);
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

class _ForgetPasswordWidget extends StatelessWidget {
  const _ForgetPasswordWidget({required this.cubit});

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginStates>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10.w),
            TextButton(
              onPressed: () {
                context.pushName(AppRoutes.forgetPasswordView,
                    arguments: {
                      "phone":cubit.controllers.phoneController.text
                    });
              },
              child: CustomText(
                text: context.translate(LangKeys.forget_password),
                color: ColorManager.mainColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.cubit});

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginFailedState) {
          if (state.msg ==
              "This account is not activated Pleaze Complete Your Register.") {
            context.pushName(AppRoutes.otpView, arguments: {
              "phone": cubit.controllers.phoneController.text,
              "email": "",
              "navigateFromForget": false,
              "navigateFromProfile": false,
            });
          }
          showMessage(
            message: state.msg,
            color: ColorManager.red,
          );
        } else if (state is NetworkErrorState) {
          showMessage(
            message: "No internet connection",
            color: ColorManager.red,
          );
        } else if (state is LoginSuccessState) {
          CacheHelper.saveToken(state.loginModel.data!.user!.token!);
          context.pushName(AppRoutes.landingViews);
        }
      },
      builder: (context, state) {
        if (state is LoginLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorManager.mainColor,
            ),
          );
        }
        return CustomElevated(
          text: context.translate(LangKeys.sign_in),
          press: () {
            cubit.login();
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}

class _OrLineWithAuthGoogle extends StatelessWidget {
  const _OrLineWithAuthGoogle({required this.cubit});

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OrDividerWidget(),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<LoginCubit, LoginStates>(
              listener: (context, state) {
                if (state is SignInWithGoogleFailedState) {
                  showMessage(
                    message: state.msg,
                    color: ColorManager.red,
                  );
                } else if (state is NetworkErrorState) {
                  showMessage(
                    message: "No internet connection",
                    color: ColorManager.red,
                  );
                } else if (state is SignInWithGoogleSuccessState) {
                  context.pushReplacementNamed(AppRoutes.landingViews);
                }
              },
              builder: (context, state) {
                if (state is SignInWithGoogleLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.mainColor,
                    ),
                  );
                }
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      cubit.signInWithGoogle();
                    },
                    child: SvgPicture.asset(
                      AssetsStrings.google,
                      height: 60.h,
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 20.w),
            BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {
              if (state is SignInWithAppleFailedState) {
                showMessage(
                  message: state.msg,
                  color: ColorManager.red,
                );
              } else if (state is NetworkErrorState) {
                showMessage(
                  message: "No internet connection",
                  color: ColorManager.red,
                );
              } else if (state is SignInWithAppleSuccessState) {
                context.pushName(AppRoutes.landingViews);
              }
            }, builder: (context, state) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    // cubit.signInWithApple();
                  },
                  child: SvgPicture.asset(
                    AssetsStrings.apple,
                    height: 60.h,
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
