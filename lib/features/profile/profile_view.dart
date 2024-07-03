import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/profile/widgets/profile_item.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            const CustomAppBarTitle(
              title: "My Account",
              withBack: false,
            ),
            30.verticalSpace,
            ListTile(
              onTap: () {},
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: ColorManager.mainColor,
              ),
              title: CustomText(
                text: "Johan marshal",
                color: ColorManager.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
            12.verticalSpace,
            const ProfileItem(
              icon: AssetsStrings.bell,
              text: "Notifications",
            ),
            const ProfileItem(
              icon: AssetsStrings.language,
              text: "Language ",
            ),
            const ProfileItem(
              icon: AssetsStrings.info,
              text: "About",
            ),
            const ProfileItem(
              icon: AssetsStrings.rateUs,
              text: "Rate Us",
            ),
            const ProfileItem(
              icon: AssetsStrings.logOut,
              text: "Log Out",
              haveTrailing: false,
            ),
          ],
        ),
      ),
    );
  }
}
