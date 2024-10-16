import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/features/profile_details/profile_details_cubit.dart';
import 'package:homez/features/profile_details/widgets/password_text_field_widget.dart';
import 'package:homez/features/search/default_search_view.dart';
import 'package:homez/injection_container.dart' as di;

class EnterPasswordToDeleteAccountView extends StatefulWidget {
  const EnterPasswordToDeleteAccountView({super.key});

  @override
  State<EnterPasswordToDeleteAccountView> createState() =>
      _EnterPasswordToDeleteAccountViewState();
}

class _EnterPasswordToDeleteAccountViewState
    extends State<EnterPasswordToDeleteAccountView> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ProfileDetailsCubit>(context);
    return BlocProvider(
      create: (context) => di.sl<ProfileDetailsCubit>(),
      child: BlocConsumer<ProfileDetailsCubit, ProfileDetailsState>(
        listener: (context, state) {
          if (state is DeleteAccountSuccessState) {
            showMessage(
                message: "Account Deleted Successfully",
                color: ColorManager.mainColor);
            context.pushReplacementNamed(AppRoutes.loginView);
          } else if (state is NetworkErrorState) {
            showMessage(
                message: "No internet connection", color: ColorManager.red);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorManager.bgColor,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorManager.white,
                ),
              ),
              backgroundColor: ColorManager.black,
              title: CustomText(
                  text: 'Delete Account',
                  color: ColorManager.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      color: ColorManager.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      text: "Enter Password to Delete Account ",
                    ),
                    SizedBox(height: 30.h),
                    BlocBuilder<ProfileDetailsCubit, ProfileDetailsState>(
                      builder: (context, state) {
                        return PasswordTextField(cubit: context.read<ProfileDetailsCubit>());
                      },
                    ),
                    SizedBox(height: 30.h),
                    CustomElevated(
                        text: 'Delete',
                        press: () {
                          context.read<ProfileDetailsCubit>().deleteAccount(
                              password:
                                  context.read<ProfileDetailsCubit>().controllers.passwordController.text);
                        },
                        btnColor: ColorManager.mainColor)
                  ]),
            ),
          );
        },
      ),
    );
  }
}
