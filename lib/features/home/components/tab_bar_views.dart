import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_tab_bar.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/home/components/custom_buy_widget.dart';
import 'package:homez/features/search/search_screen.dart';

class TabBarWidgetViews extends StatelessWidget {
  const TabBarWidgetViews({super.key});

  @override
  Widget build(BuildContext context) {
    return   DefaultTabController(
      length: 2,
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
        pages:  [
          SearchScreenViews(),
          CustomBuyWidget(),
        ],
        isScrollable: false,
      ),
    );
  }
}
