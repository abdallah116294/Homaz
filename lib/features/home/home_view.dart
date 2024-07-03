import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_tab_bar.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/search/search_screen.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 40.w),
        child: Column(
          children: [
            Row(
              children: [
                CustomText(
                  text: 'Homz ',
                  color: ColorManager.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 32.sp,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: SvgIcon(
                    icon: 'assets/icons/notification.svg',
                    color: ColorManager.white,
                    height: 25,
                  ),
                ),
              ],
            ),
            25.verticalSpace,
            Expanded(
              child: CustomTabBar(
                tabs: [
                  CustomText(
                    text: 'Rent',
                    color: ColorManager.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                  CustomText(
                    text: 'Buy',
                    color: ColorManager.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ],
                pages: const [
                  SearchScreenViews(),
                  SearchScreenViews(),
                ],
                isScrollable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
