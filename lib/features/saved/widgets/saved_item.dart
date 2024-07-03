import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/details/widgets/icon_text.dart';

class SavedItem extends StatelessWidget {
  const SavedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ColorManager.grey12,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 0.3.sh,
                width: 1.sw,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: Image.asset(
                    AssetsStrings.detailsImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: ColorManager.black2,
                  child: SvgIcon(
                    icon: AssetsStrings.heartFillRed,
                    color: ColorManager.red,
                    height: 22,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Colonial Jolliya",
                            color: ColorManager.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          CustomText(
                            text: "450 Elm Avenue, Jolliya, NY 122",
                            color: ColorManager.grey10,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: ColorManager.mainColor,
                          child: SvgIcon(
                            icon: AssetsStrings.send,
                            color: ColorManager.white,
                            height: 20,
                          ),
                        ),
                        6.horizontalSpace,
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: ColorManager.mainColor,
                          child: SvgIcon(
                            icon: AssetsStrings.phone,
                            color: ColorManager.white,
                            height: 20,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                10.verticalSpace,
                const Row(
                  children: [
                    Expanded(
                      child: RowIconTextWidget(
                        icon: AssetsStrings.bath,
                        text: "4 Bath",
                      ),
                    ),
                    Expanded(
                      child: RowIconTextWidget(
                        icon: AssetsStrings.bed,
                        text: "5 Beds",
                      ),
                    ),
                    Expanded(
                      child: RowIconTextWidget(
                        icon: AssetsStrings.widget,
                        text: "450m",
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                CustomText(
                  text: "\$800,200",
                  color: ColorManager.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
