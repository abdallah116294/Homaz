import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_tab_bar.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/home/components/tab_bar_views.dart';
import 'package:homez/features/home/components/tab_bar_widget.dart';
import 'package:homez/features/notification/notification_view.dart';
import 'package:homez/features/search/search_screen.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                CustomText(
                  text: "Homz",
                  color: ColorManager.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 32.sp,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    MagicRouter.navigateTo(
                      page: const NotificationView(),
                    );
                  },
                  icon: SvgIcon(
                    icon: AssetsStrings.bell,
                    color: ColorManager.white,
                    height: 25,
                  ),
                ),
              ],
            ),
            25.verticalSpace,
            const Expanded(
              child: TabBarWidget(
                tabs: [
                  Text(
                    'Commercial',
                    style: TextStyle(fontFamily: 'Regular'),
                  ),
                  Text(
                    'Residential',
                    style: TextStyle(fontFamily: 'Regular'),
                  ),
                  Text(
                    'Shops',
                    style: TextStyle(fontFamily: 'Regular'),
                  ),
                ],
                pages: [TabBarWidgetViews(), TabBarWidgetViews(), TabBarWidgetViews()],
                isScrollable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
