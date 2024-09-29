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
          create: (context) => di.sl<AppartmentDetailsCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              di.sl<TakeLookCubit>()..takeLook(apartmentId: apartmentId),
        ),
      ],
      child: BlocConsumer<TakeLookCubit, TakeLookState>(
        listener: (context, state) {
          if (state is CreateChatSuccess) {}
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
          return state is TakeLookSuccess
              ? SafeArea(
                  child: Scaffold(
                    backgroundColor: const Color.fromRGBO(161, 161, 161, 1),
                    appBar: AppBar(
                      toolbarHeight: 120.h,
                      // elevation: 5,
                      centerTitle: true,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.black),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      fontSize: 14.sp),
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
                              StackedImageSlider(
                                  takeLookData: state.takeLookData),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<AppartmentDetailsCubit>()
                                          .addToFavorite(
                                              id: state.takeLookData.data!
                                                  .apartments!.id!)
                                          .then((value) {
                                        showMessage(
                                            message:
                                                'Remove From Favorite Successfully',
                                            color: ColorManager.blueColor);
                                      });
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
                              ExpandableText(state
                                  .takeLookData.data!.apartments!.description!
                                  .toString()),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 41.h,
                                    width: 140.w,
                                    child: CustomElevated(
                                        text: 'Call',
                                        press: () {},
                                        btnColor: ColorManager.mainColor),
                                  ),
                                  SizedBox(
                                    height: 41.h,
                                    width: 140.w,
                                    child: CustomElevated(
                                        text: 'Message',
                                        press: () {
                                          context
                                              .read<AppartmentDetailsCubit>()
                                              .createChat(
                                                  apartmentId: apartmentId)
                                              .then((value) {
                                            context.pushName(
                                                AppRoutes.chatScreen,
                                                arguments: {
                                                  'chatName': state.takeLookData
                                                      .data!.apartments!.name
                                                      .toString(),
                                                  "imageUrl": state.takeLookData
                                                      .data!.apartments!.images
                                                      .toString(),
                                                  "roomId": state.takeLookData
                                                      .data!.apartments!.id
                                                });
                                          });
                                        },
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
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
