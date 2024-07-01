import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/features/register/view.dart';

class RegisterLineWidget extends StatelessWidget {
  const RegisterLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Don’t have an account?  ",
        style: TextStyle(
          color: ColorManager.grey11,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: "Sign up",
            style: TextStyle(
              color: ColorManager.mainColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                MagicRouter.navigateTo(
                  page: const RegisterView(),
                );
              },
          ),
        ],
      ),
    );
  }
}
