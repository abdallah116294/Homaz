import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';

class LegalAndPoliciesScreen extends StatelessWidget {
  const LegalAndPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      appBar: AppBar(
        backgroundColor: ColorManager.bgColor,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorManager.white,
            )),
        title: CustomText(
            text: context.translate(LangKeys.legal_and_policies),
            color: ColorManager.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
                text: '${context.translate(LangKeys.terms)}:',
                color: ColorManager.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp),
            SizedBox(
              height: 6.h,
            ),
            CustomText(
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                color: Color.fromRGBO(239, 239, 239, 1),
                fontWeight: FontWeight.w500,
                maxLines: 10,
                fontSize: 14.sp),
            SizedBox(
              height: 20.h,
            ),
            CustomText(
                text: context.translate(LangKeys.change_service),
                color: ColorManager.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp),
            SizedBox(
              height: 6.h,
            ),
            CustomText(
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                color: Color.fromRGBO(239, 239, 239, 1),
                fontWeight: FontWeight.w500,
                maxLines: 10,
                fontSize: 14.sp)
          ],
        ),
      ),
    );
  }
}
