import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color backgroundColor, leadingColor, textColor;
  final bool withLeading;

  const CustomAppBar({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.leadingColor,
    required this.textColor,
    this.withLeading = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(50.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: withLeading
          ? IconButton(
              onPressed: () {
                MagicRouter.navigatePop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: leadingColor,
                size: 22.sp,
              ),
            )
          : const SizedBox.shrink(),
      title: CustomText(
        text: text,
        color: textColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
      centerTitle: true,
    );
  }
}
