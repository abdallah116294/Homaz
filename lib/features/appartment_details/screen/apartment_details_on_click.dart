import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/navigator.dart';
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
import 'package:homez/features/take_look/cubit/take_look_cubit.dart';
import 'package:homez/injection_container.dart' as di;

class ApartmentDetailsOnClick extends StatelessWidget {
  const ApartmentDetailsOnClick({super.key, required this.apartmentId});
  final int apartmentId;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AppartmentDetailsCubit>()
             ..checkIfIsFavorite(isFavorite: true),
        ),
        BlocProvider(
          create: (context) =>
              di.sl<TakeLookCubit>()..takeLook(apartmentId: apartmentId),
        ),
      ],
      child: BlocConsumer<TakeLookCubit, TakeLookState>(
        listener: (context, state) {
          if (state is CreateChatSuccessTakeLookCubit) {
            context.pushName(AppRoutes.chatScreen, arguments: {
              'chatName': '',
              "imageUrl": '',
              "roomId": state.createChatSuccessful.data!.chat!.id
            });
          }
          // if (state is AddToFavoriteSuccess) {
          //   showMessage(
          //       message: 'Add To Favorite Successfully',
          //       color: ColorManager.blueColor);
          // } else if (state is AddToFavoriteFailed) {
          //   showMessage(
          //       message: 'Error Add To Favorite',
          //       color: ColorManager.red);
          // }
        },
        builder: (context, state) {
          if (state is TakeLookSuccess) {
            final takelookdata = state.takeLookData;
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
                      text: 'Apartment Details',
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
                                  text: state
                                      .takeLookData.data!.apartments!.name!
                                      .split(' ')
                                      .take(5)
                                      .join(' ')
                                      .toString(),
                                  color: ColorManager.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.sp),
                              CustomText(
                                  text:
                                      '\$ ${state.takeLookData.data!.apartments!.buyPrice}',
                                  color: ColorManager.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.sp),
                            ],
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          StackedImageSlider(takeLookData: state.takeLookData),
                          SizedBox(
                            height: 16.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                  text: state
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
                                          log("Apartment Id:${takelookdata.data!.apartments!.id!}");
                                          context
                                              .read<AppartmentDetailsCubit>()
                                              .addToFavorite(
                                                  id: apartmentId)
                                              .then((value) {
                                            if (takelookdata.data!
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
                                              }

                                             else if (state.isAlreadyFavorite ==
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
                                              icon: state.isAlreadyFavorite
                                                      ==true
                                                  ? AssetsStrings.heartFillRed
                                                  : AssetsStrings.favorite,
                                              color: state.isAlreadyFavorite
                                                     ==true
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
                                state.takeLookData.data!.apartments!.amenities
                                    .length, (index) {
                          return Expanded(
                            child: RowIconTextWidget(
                              icon:state. takeLookData.data!.apartments!.amenities[index].image.toString() ,
                              text: state. takeLookData.data!.apartments!.amenities[index].count.toString()+state. takeLookData.data!.apartments!.amenities[index].name.toString(),
                            ),
                          );
                        })
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          ExpandableText(state
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
                                    text: 'Call',
                                    press: () {
                                       CallModelBottomSheet.callAction(context,state.takeLookData.data!.apartments!.contact.first.phone.toString());
                                    },
                                    btnColor: ColorManager.mainColor),
                              ),
                              BlocConsumer<AppartmentDetailsCubit,
                                  AppartmentDetailsState>(
                                listener: (context, state) {
                                  if (state is CreateChatSuccess) {
                                    context.pushName(AppRoutes.chatScreen,
                                        arguments: {
                                          "chatName": takelookdata
                                              .data!.apartments!.name
                                              .toString(),
                                          "imageUrl": takelookdata
                                              .data!.apartments!.mainImage
                                              .toString(),
                                          "roomId": state.createChatSuccessful
                                              .data!.chat!.id
                                        });
                                  } else if (state is ChatStatusChanged) {
                                    if (state.hasAlreadyChats.isNotEmpty) {
                                      final chat = state.hasAlreadyChats
                                          .firstWhere((chat) =>
                                              chat.aparmentId ==
                                              takelookdata
                                                  .data!.apartments!.id);
                                      final roomId = chat.chatId;
                                      log(takelookdata.data!.apartments!.images
                                          .toString());
                                      context.pushName(AppRoutes.chatScreen,
                                          arguments: {
                                            "chatName": takelookdata
                                                .data!.apartments!.name
                                                .toString(),
                                            "imageUrl": takelookdata
                                                .data!.apartments!.mainImage
                                                .toString(),
                                            "roomId": roomId
                                          });
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  return SizedBox(
                                    height: 41.h,
                                    width: 140.w,
                                    child: CustomElevated(
                                        text: 'Message',
                                        press: () {
                                        if (takelookdata.data!
                                                .apartments!.chatId !=
                                            null) {
                                          context.pushName(AppRoutes.chatScreen,
                                              arguments: {
                                                "chatName": takelookdata
                                                    .data!.apartments!.name
                                                    .toString(),
                                                "imageUrl":takelookdata
                                                    .data!.apartments!.mainImage
                                                    .toString(),
                                                "roomId": takelookdata
                                                    .data!.apartments!.chatId
                                              });
                                        } else {
                                          context
                                              .read<AppartmentDetailsCubit>()
                                              .checkIfIsHasChat(
                                                  apartmentId: takelookdata
                                                      .data!
                                                      .apartments!
                                                      .id!);
                                        }
                                          // context
                                          //     .read<TakeLookCubit>()
                                          //     .createChat(
                                          //         apartmentId: apartmentId);
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
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // return state is TakeLookSuccess
          //     ? SafeArea(
          //         child: Scaffold(
          //           backgroundColor: const Color.fromRGBO(161, 161, 161, 1),
          //           appBar: AppBar(
          //             toolbarHeight: 120.h,
          //             // elevation: 5,
          //             centerTitle: true,
          //             leading: IconButton(
          //               icon: const Icon(Icons.arrow_back_ios,
          //                   color: Colors.black),
          //               onPressed: () {
          //                 MagicRouter.navigatePop();
          //               },
          //             ),
          //             backgroundColor: const Color.fromRGBO(161, 161, 161, 1),
          //             title: CustomText(
          //                 text: 'Apartment Details',
          //                 color: ColorManager.black,
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 17.sp),
          //           ),
          //           body: Container(
          //             width: 375.w,
          //             height: 812.h,
          //             decoration: BoxDecoration(
          //                 color: ColorManager.bgColor,
          //                 borderRadius: BorderRadius.only(
          //                   topLeft: Radius.circular(20.r),
          //                   topRight: Radius.circular(20.r),
          //                 )),
          //             child: Padding(
          //               padding: const EdgeInsets.all(16.0),
          //               child: SingleChildScrollView(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         CustomText(
          //                             text: state
          //                                 .takeLookData.data!.apartments!.name!
          //                                 .split(' ')
          //                                 .take(5)
          //                                 .join(' ')
          //                                 .toString(),
          //                             color: ColorManager.white,
          //                             fontWeight: FontWeight.w400,
          //                             fontSize: 18.sp),
          //                         CustomText(
          //                             text:
          //                                 '\$ ${state.takeLookData.data!.apartments!.buyPrice}',
          //                             color: ColorManager.white,
          //                             fontWeight: FontWeight.w400,
          //                             fontSize: 18.sp),
          //                       ],
          //                     ),
          //                     SizedBox(
          //                       height: 16.h,
          //                     ),
          //                     StackedImageSlider(
          //                         takeLookData: state.takeLookData),
          //                     SizedBox(
          //                       height: 16.h,
          //                     ),
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         CustomText(
          //                             text: state
          //                                 .takeLookData.data!.apartments!.name!
          //                                 .split(' ')
          //                                 .take(5)
          //                                 .join(' ')
          //                                 .toString(),
          //                             color: ColorManager.white,
          //                             fontWeight: FontWeight.w400,
          //                             fontSize: 16.sp),
          //                         BlocBuilder<AppartmentDetailsCubit,
          //                             AppartmentDetailsState>(
          //                           builder: (context, state) {
          //                             return state is FavoriteStatusChanged
          //                                 ? GestureDetector(
          //                                     onTap: () {
          //                                       //  log("Apartment Id:${.data!.apartments!.id!}");
          //                                       context
          //                                           .read<
          //                                               AppartmentDetailsCubit>()
          //                                           .addToFavorite(
          //                                               id: apartmentId)
          //                                           .then((value) {
          //                                         context
          //                                             .read<
          //                                                 AppartmentDetailsCubit>()
          //                                             .checkIfIsFavorite(
          //                                                 id: apartmentId);
          //                                       });
          //                                     },
          //                                     child: CircleAvatar(
          //                                       radius: 20,
          //                                       backgroundColor: Colors.black,
          //                                       child: SvgIcon(
          //                                         icon: state.isAlreadyFavorite
          //                                                 .isNotEmpty
          //                                             ? AssetsStrings
          //                                                 .heartFillRed
          //                                             : AssetsStrings.favorite,
          //                                         color: state.isAlreadyFavorite
          //                                                 .isNotEmpty
          //                                             ? Colors.red
          //                                             : Colors.white,
          //                                       ),
          //                                     ),
          //                                   )
          //                                 : const SizedBox();
          //                           },
          //                         ),
          //                       ],
          //                     ),
          //                     SizedBox(
          //                       height: 16.h,
          //                     ),
          //                     const Row(
          //                       children: [
          //                         Expanded(
          //                           child: RowIconTextWidget(
          //                             icon: AssetsStrings.bath,
          //                             text: "4 Bath",
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: RowIconTextWidget(
          //                             icon: AssetsStrings.bed,
          //                             text: "5 Beds",
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: RowIconTextWidget(
          //                             icon: AssetsStrings.widget,
          //                             text: "450m",
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     SizedBox(
          //                       height: 16.h,
          //                     ),
          //                     ExpandableText(state
          //                         .takeLookData.data!.apartments!.description!
          //                         .toString()),
          //                     SizedBox(
          //                       height: 16.h,
          //                     ),
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceEvenly,
          //                       children: [
          //                         SizedBox(
          //                           height: 41.h,
          //                           width: 140.w,
          //                           child: CustomElevated(
          //                               text: 'Call',
          //                               press: () {},
          //                               btnColor: ColorManager.mainColor),
          //                         ),
          //                         BlocConsumer<AppartmentDetailsCubit,
          //                             AppartmentDetailsState>(
          //                           listener: (context, state) {
          //                             if (state is ChatStatusChanged) {
          //                               if (state.hasAlreadyChats.isNotEmpty) {
          //                                 final chat = state.hasAlreadyChats
          //                                     .firstWhere((chat) =>
          //                                         chat.aparmentId ==
          //                                         takelookdata
          //                                             .data!.apartments!.id);
          //                                 final roomId = chat.chatId;
          //                                 log(takeLookData
          //                                     .data!.apartments!.images
          //                                     .toString());
          //                                 context.pushName(AppRoutes.chatScreen,
          //                                     arguments: {
          //                                       "chatName": takeLookData
          //                                           .data!.apartments!.name
          //                                           .toString(),
          //                                       "imageUrl": takeLookData
          //                                           .data!.apartments!.mainImage
          //                                           .toString(),
          //                                       "roomId": roomId
          //                                     });
          //                               }
          //                             }
          //                           },
          //                           builder: (context, state) {
          //                             return SizedBox(
          //                               height: 41.h,
          //                               width: 140.w,
          //                               child: CustomElevated(
          //                                   text: 'Message',
          //                                   press: () {
          //                                     context
          //                                         .read<TakeLookCubit>()
          //                                         .createChat(
          //                                             apartmentId: apartmentId);
          //                                   },
          //                                   btnColor: ColorManager.mainColor),
          //                             );
          //                           },
          //                         )
          //                       ],
          //                     )
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     : const Center(
          //         child: CircularProgressIndicator(),
          //       );
        },
      ),
    );
  }
}
