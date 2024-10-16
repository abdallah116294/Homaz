import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/appartment_details/cubit/appartment_details_cubit.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/appartment_details/widgets/dialog_alert_widget.dart';
import 'package:homez/features/details/widgets/icon_text.dart';
import 'package:homez/features/saved/cubit/favorite_cubit.dart';
import 'package:homez/injection_container.dart' as di;

class SavedItem extends StatelessWidget {
  const SavedItem({super.key, required this.apartment, required this.oTap});
  // final String maniImage;
  // final String name;
  // final int buy_price;
  final Datum apartment;
  final VoidCallback oTap;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<FavoriteCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<AppartmentDetailsCubit>(),
        ),
      ],
      child: Container(
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
                    child: Image.network(
                      apartment.mainImage.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: oTap,
                    child: CircleAvatar(
                      radius: 25.r,
                      backgroundColor: ColorManager.black2,
                      child: SvgIcon(
                        icon: AssetsStrings.heartFillRed,
                        color: ColorManager.red,
                        height: 22.h,
                      ),
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
                              text: apartment.name.toString(),
                              color: ColorManager.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            // CustomText(
                            //   text: "450 Elm Avenue, Jolliya, NY 122",
                            //   color: ColorManager.grey10,
                            //   fontSize: 18.sp,
                            //   fontWeight: FontWeight.w400,
                            //   maxLines: 2,
                            // ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          BlocConsumer<AppartmentDetailsCubit,
                              AppartmentDetailsState>(
                            listener: (context, state) {
                              if (state is CreateChatSuccess) {
                                log("First Navigate");
                                context
                                    .pushName(AppRoutes.chatScreen, arguments: {
                                  "chatName": apartment.name.toString(),
                                  "imageUrl": apartment.mainImage.toString(),
                                  "roomId":
                                      state.createChatSuccessful.data!.chat!.id
                                });
                              } else if (state is ChatStatusChanged) {
                                if (state.hasAlreadyChats.isNotEmpty) {
                                  log("Second Navigate");
                                  final chat = state.hasAlreadyChats.firstWhere(
                                      (chat) =>
                                          chat.aparmentId == apartment.id);
                                  final roomId = chat.chatId;
                                  log(apartment.images.toString());
                                  context.pushName(AppRoutes.chatScreen,
                                      arguments: {
                                        "chatName": apartment.name.toString(),
                                        "imageUrl":
                                            apartment.mainImage.toString(),
                                        "roomId": roomId
                                      });
                                }
                              }
                            },
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<AppartmentDetailsCubit>()
                                      .checkIfIsHasChat(
                                          apartmentId: apartment.id!);
                                },
                                child: CircleAvatar(
                                  radius: 18.r,
                                  backgroundColor: ColorManager.mainColor,
                                  child: SvgIcon(
                                    icon: AssetsStrings.send,
                                    color: ColorManager.white,
                                    height: 30.h,
                                  ),
                                ),
                              );
                            },
                          ),
                          6.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              CallModelBottomSheet.callAction(context,
                                  apartment.contact.first.phone.toString());
                            },
                            child: CircleAvatar(
                              radius: 18.r,
                              backgroundColor: ColorManager.mainColor,
                              child: SvgIcon(
                                icon: AssetsStrings.phone,
                                color: ColorManager.white,
                                height: 30.h,
                              ),
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
                    text: apartment.buyPrice.toString(),
                    color: ColorManager.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
