import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/appartment_details/cubit/appartment_details_cubit.dart';
import 'package:homez/features/appartment_details/widgets/expandable_text.dart';
import 'package:homez/features/appartment_details/widgets/stack_image_slider.dart';
import 'package:homez/features/details/widgets/icon_text.dart';
import 'package:homez/features/take_look/data/model/take_look_model.dart';
import 'package:homez/injection_container.dart' as di;

class ApartmentDetailsAfterTakeLook extends StatelessWidget {
  ApartmentDetailsAfterTakeLook({super.key, required this.takeLookData});
  TakeLookData takeLookData;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AppartmentDetailsCubit>(),
      child: BlocConsumer<AppartmentDetailsCubit, AppartmentDetailsState>(
        listener: (context, state) {
          if (state is AddToFavoriteSuccess) {
            showMessage(
                message: 'Add To Favorite Successfully',
                color: ColorManager.blueColor);
          } else if (state is RemoveFromFavoriteSuccess) {
            showMessage(
                message: 'Remove From Favorite Successfully',
                color: ColorManager.blueColor);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color.fromRGBO(161, 161, 161, 1),
              appBar: AppBar(
                toolbarHeight: 120.h,
                // elevation: 5,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    MagicRouter.navigatePop();
                  },
                ),
                backgroundColor: const Color.fromRGBO(161, 161, 161, 1),
                title: CustomText(
                    text: context.translate(LangKeys.apartment_detials),
                    color: ColorManager.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp),
              ),
              body: Container(
                width: 375.w,
                height: 812.h,
                decoration: BoxDecoration(
                    color: ColorManager.bgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                                text: takeLookData.data!.apartments!.name!
                                    .split(' ')
                                    .take(5)
                                    .join(' ')
                                    .toString(),
                                color: ColorManager.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp),
                            CustomText(
                                text:
                                    '\$ ${takeLookData.data!.apartments!.buyPrice}',
                                color: ColorManager.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        StackedImageSlider(takeLookData: takeLookData),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                                text: takeLookData.data!.apartments!.name!
                                    .split(' ')
                                    .take(5)
                                    .join(' ')
                                    .toString(),
                                color: ColorManager.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp),
                            GestureDetector(
                              onTap: () {
                                log("Apartment Id:${takeLookData.data!.apartments!.id!}");
                                context
                                    .read<AppartmentDetailsCubit>()
                                    .addToFavorite(
                                        id: takeLookData.data!.apartments!.id!);
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black,
                                child: SvgIcon(
                                  icon: AssetsStrings.favorite,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
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
                        SizedBox(
                          height: 16.h,
                        ),
                        ExpandableText(takeLookData
                            .data!.apartments!.description!
                            .toString()),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 41.h,
                              width: 140.w,
                              child: CustomElevated(
                                  text: context.translate(LangKeys.call),
                                  press: () {},
                                  btnColor: ColorManager.mainColor),
                            ),
                            SizedBox(
                              height: 41.h,
                              width: 140.w,
                              child: CustomElevated(
                                  text: context.translate(LangKeys.message),
                                  press: () {},
                                  btnColor: ColorManager.mainColor),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
