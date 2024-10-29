import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/appartment_details/cubit/appartment_details_cubit.dart';
import 'package:homez/features/appartment_details/widgets/dialog_alert_widget.dart';
import 'package:homez/features/appartment_details/widgets/expandable_text.dart';
import 'package:homez/features/appartment_details/widgets/stack_image_slider.dart';
import 'package:homez/features/details/widgets/icon_text.dart';
import 'package:homez/features/take_look/data/model/take_look_model.dart';
import 'package:homez/injection_container.dart' as di;

class ApartmentDetailsAfterTakeLook extends StatefulWidget {
  ApartmentDetailsAfterTakeLook({super.key, required this.takeLookData});
  TakeLookData takeLookData;

  @override
  State<ApartmentDetailsAfterTakeLook> createState() =>
      _ApartmentDetailsAfterTakeLookState();
}

class _ApartmentDetailsAfterTakeLookState
    extends State<ApartmentDetailsAfterTakeLook> {
  @override
  Widget build(BuildContext context) {
    bool isFavorite = widget.takeLookData.data!.apartments!.isFavorite!;
    log(widget.takeLookData.data!.apartments!.isFavorite.toString());
    return BlocProvider(
      create: (context) => di.sl<AppartmentDetailsCubit>()
        ..checkIfIsFavorite(isFavorite: isFavorite),
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
          } else if (state is CreateChatSuccess) {
            context.pushName(AppRoutes.chatScreen, arguments: {
              "chatName": widget.takeLookData.data!.apartments!.name.toString(),
              "imageUrl":
                  widget.takeLookData.data!.apartments!.mainImage.toString(),
              "roomId": state.createChatSuccessful.data!.chat!.id
            });
          } else if (state is ChatStatusChanged) {
            if (state.hasAlreadyChats.isNotEmpty) {
              final chat = state.hasAlreadyChats.firstWhere((chat) =>
                  chat.aparmentId == widget.takeLookData.data!.apartments!.id);
              final roomId = chat.chatId;
              log(widget.takeLookData.data!.apartments!.images.toString());
              context.pushName(AppRoutes.chatScreen, arguments: {
                "chatName":
                    widget.takeLookData.data!.apartments!.name.toString(),
                "imageUrl":
                    widget.takeLookData.data!.apartments!.mainImage.toString(),
                "roomId": roomId
              });
            }
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
                    context.pop();
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
                                text: widget
                                    .takeLookData.data!.apartments!.name!
                                    .split(' ')
                                    .take(5)
                                    .join(' ')
                                    .toString(),
                                color: ColorManager.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp),
                            CustomText(
                                text:
                                    '\$ ${widget.takeLookData.data!.apartments!.buyPrice}',
                                color: ColorManager.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        StackedImageSlider(takeLookData: widget.takeLookData),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                                text: widget
                                    .takeLookData.data!.apartments!.name!
                                    .split(' ')
                                    .take(5)
                                    .join(' ')
                                    .toString(),
                                color: ColorManager.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp),
                            BlocBuilder<AppartmentDetailsCubit,
                                AppartmentDetailsState>(
                              builder: (context, state) {
                                return state is FavoriteStatusChanged
                                    ? GestureDetector(
                                        onTap: () {
                                          log("state.isAlreadyFavorite:${state.isAlreadyFavorite}");
                                          log("Apartment Id:${widget.takeLookData.data!.apartments!.id!}");
                                          context
                                              .read<AppartmentDetailsCubit>()
                                              .addToFavorite(
                                                  id: widget.takeLookData.data!
                                                      .apartments!.id!)
                                              .then((value) {
                                            if (widget.takeLookData.data!
                                                .apartments!.isFavorite!) {
                                              if (state.isAlreadyFavorite ==
                                                  true) {
                                                context
                                                    .read<
                                                        AppartmentDetailsCubit>()
                                                    .checkIfIsFavorite(
                                                        isFavorite: false);
                                              } else if (state
                                                      .isAlreadyFavorite ==
                                                  false) {
                                                context
                                                    .read<
                                                        AppartmentDetailsCubit>()
                                                    .checkIfIsFavorite(
                                                        isFavorite: true);
                                              }
                                            } else {
                                              if (state.isAlreadyFavorite ==
                                                  false) {
                                                context
                                                    .read<
                                                        AppartmentDetailsCubit>()
                                                    .checkIfIsFavorite(
                                                        isFavorite: true);
                                              } else if (state
                                                      .isAlreadyFavorite ==
                                                  true) {
                                                context
                                                    .read<
                                                        AppartmentDetailsCubit>()
                                                    .checkIfIsFavorite(
                                                        isFavorite: false);
                                              }
                                            }
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black,
                                          child: SvgIcon(
                                            icon:
                                                state.isAlreadyFavorite == true
                                                    ? AssetsStrings.heartFillRed
                                                    : AssetsStrings.favorite,
                                            color:
                                                state.isAlreadyFavorite == true
                                                    ? Colors.red
                                                    : Colors.white,
                                          ),
                                        ),
                                      )
                                    : const SizedBox();
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                            children: List.generate(
                                widget.takeLookData.data!.apartments!.amenities
                                    .length, (index) {
                          return Expanded(
                            child: RowIconTextWidget(
                              icon:widget. takeLookData.data!.apartments!.amenities[index].image.toString() ,
                              text: widget. takeLookData.data!.apartments!.amenities[index].count.toString()+widget. takeLookData.data!.apartments!.amenities[index].name.toString(),
                            ),
                          );
                        })
                            // [
                            //   Expanded(
                            //     child: RowIconTextWidget(
                            //       icon: AssetsStrings.bath,
                            //       text: "4 Bath",
                            //     ),
                            //   ),
                            //   Expanded(
                            //     child: RowIconTextWidget(
                            //       icon: AssetsStrings.bed,
                            //       text: "5 Beds",
                            //     ),
                            //   ),
                            //   Expanded(
                            //     child: RowIconTextWidget(
                            //       icon: AssetsStrings.widget,
                            //       text: "450m",
                            //     ),
                            //   ),
                            // ],
                            ),
                        SizedBox(
                          height: 16.h,
                        ),
                        ExpandableText(widget
                            .takeLookData.data!.apartments!.description!
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
                                  press: () {
                                    CallModelBottomSheet.callAction(
                                        context,
                                        widget.takeLookData.data!.apartments!
                                            .contact.first.phone
                                            .toString());
                                  },
                                  btnColor: ColorManager.mainColor),
                            ),
                            BlocBuilder<AppartmentDetailsCubit,
                                AppartmentDetailsState>(
                              builder: (context, state) {
                                return SizedBox(
                                  height: 41.h,
                                  width: 140.w,
                                  child: CustomElevated(
                                      text: context.translate(LangKeys.message),
                                      press: () {
                                        if (widget.takeLookData.data!
                                                .apartments!.chatId !=
                                            null) {
                                          context.pushName(AppRoutes.chatScreen,
                                              arguments: {
                                                "chatName": widget.takeLookData
                                                    .data!.apartments!.name
                                                    .toString(),
                                                "imageUrl": widget.takeLookData
                                                    .data!.apartments!.mainImage
                                                    .toString(),
                                                "roomId": widget.takeLookData
                                                    .data!.apartments!.chatId
                                              });
                                        } else {
                                          context
                                              .read<AppartmentDetailsCubit>()
                                              .checkIfIsHasChat(
                                                  apartmentId: widget
                                                      .takeLookData
                                                      .data!
                                                      .apartments!
                                                      .id!);
                                        }
                                        // context
                                        //     .read<AppartmentDetailsCubit>()
                                        //     .checkIfIsHasChat(
                                        //         apartmentId: widget.takeLookData
                                        //             .data!.apartments!.id!);
                                      },
                                      btnColor: ColorManager.mainColor),
                                );
                              },
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
