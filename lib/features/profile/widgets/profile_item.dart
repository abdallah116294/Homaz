import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
    this.haveTrailing = true,
  });

  final VoidCallback onTap;
  final String icon;
  final String text;
  final bool haveTrailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SvgIcon(
        icon: icon,
        color: ColorManager.white,
        height: 25.h,
      ),
      title: CustomText(
        text: text,
        color: ColorManager.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
      ),
      trailing: haveTrailing
          ? const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            )
          : const SizedBox(),
    );
  }
}
