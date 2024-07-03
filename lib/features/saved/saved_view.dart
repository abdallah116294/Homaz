import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/features/details/details_view.dart';

import 'widgets/saved_item.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBarTitle(
                title: "Saved",
                withBack: false,
              ),
              10.verticalSpace,
              GestureDetector(
                onTap: () {
                  MagicRouter.navigateTo(
                    page: const DetailsView(),
                  );
                },
                child: const SavedItem(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
