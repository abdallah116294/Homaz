import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:pinput/pinput.dart';

class PinPutWidget extends StatelessWidget {
  final TextEditingController controller;

  const PinPutWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Localizations.override(
        context: context,
        locale: const Locale("en"),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.06.sh),
          child: Pinput(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            length: 4,
            controller: controller,
            defaultPinTheme: _buildPinTheme(context),
            focusedPinTheme: _buildPinTheme(context, focused: true),
            errorPinTheme: _buildPinTheme(context, hasError: true),
          ),
        ),
      ),
    );
  }

  PinTheme _buildPinTheme(BuildContext context,
      {bool focused = false, bool hasError = false}) {
    return PinTheme(
      height: 56.h,
      width: 56.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      textStyle: TextStyle(
        color: ColorManager.white,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 0.0015.sh,
          color: hasError
              ? ColorManager.red
              : focused
                  ? ColorManager.mainColor
                  : ColorManager.grey10,
        ),
      ),
    );
  }
}
