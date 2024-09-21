import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/app_methods.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/take_look/SweetNavBar/src/sweet_nav_bar.dart';
import 'package:homez/features/take_look/cubit/take_look_cubit.dart';
import 'package:story_view/story_view.dart';
import 'package:homez/injection_container.dart' as di;

class TakeLookScreen extends StatelessWidget {
  const TakeLookScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return TakeLookBody(
      isResidential: true,
      isShops: false,
      id: id,
    );
  }
}

class TakeLookBody extends StatefulWidget {
  const TakeLookBody({
    super.key,
    required this.isResidential,
    required this.isShops,
    required this.id,
  });

  final bool isResidential;
  final bool isShops;
  final int id;

  @override
  _TakeLookBodyState createState() => _TakeLookBodyState();
}

class _TakeLookBodyState extends State<TakeLookBody> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  int cIndex = 0;
  final iconLinearGradiant = List<Color>.from([
    const Color.fromARGB(255, 251, 2, 197),
    const Color.fromARGB(255, 72, 3, 80)
  ]);

  @override
  Widget build(BuildContext context) {
    storyItem({required String image}) {
      return StoryItem.pageImage(
        imageFit: BoxFit.fill,
        url: image,
        // caption: const Text(
        //   "Still sampling",
        //   style: TextStyle(
        //     fontSize: 15,
        //     color: Colors.white,
        //   ),
        //   textAlign: TextAlign.center,
        // ),
        controller: storyController,
      );
    }

    List<StoryItem> storyItemList = [];
    //  List<StoryItem> storyItemList =[];
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            di.sl<TakeLookCubit>()..takeLook(apartmentId: widget.id),
        child: BlocConsumer<TakeLookCubit, TakeLookState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is TakeLookSuccess) {
              List<String> newImages =
                  state.takeLookData.data!.apartments!.images;
              storyItemList.addAll(
                newImages.map((image) => storyItem(image: image)).toList(),
              );
              return Stack(children: [
                StoryView(
                  storyItems: storyItemList,
                  onStoryShow: (storyItem, index) {
                    print("Showing a story");
                  },
                  onComplete: () {
                    log('ApartmentID:${state.takeLookData.data!.apartments!.id}');
                    context.pushName(AppRoutes.apartmentDetailsView,arguments: {
                      "apartmentId":state.takeLookData.data!.apartments!.id,
                      "takeLookData":state.takeLookData,
                    } ,);
                    // MagicRouter.navigateTo(
                    //     page: ApartmentDetailsScreen(
                    //   takeLookData: state.takeLookData,
                    // ));
                  },
                  progressPosition: ProgressPosition.top,
                  indicatorColor: Colors.black,
                  indicatorHeight: IndicatorHeight.small,
                  indicatorOuterPadding: const EdgeInsets.all(16),
                  repeat: false,
                  controller: storyController,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 80.h),
                  child: GestureDetector(
                    onTap: () {
                      MagicRouter.navigatePop();
                    },
                    child: CircleAvatar(
                        radius: 26,
                        backgroundColor: ColorManager.black,
                        child: const SvgIcon(
                            height: 40,
                            icon: AssetsStrings.back,
                            color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomText(
                                  text: 'Araay',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.sp),
                              CustomText(
                                  text: 'Apartments',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.sp),
                              CustomText(
                                  text:
                                      '\$  ${CacheHelper.get(key: "selected_language") == "en" ? state.takeLookData.data!.apartments!.buyPrice : AppMethods.replaceFarsiNumber(state.takeLookData.data!.apartments!.buyPrice.toString())}',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                  radius: 26,
                                  backgroundColor: widget.isShops
                                      ? Colors.black
                                      : ColorManager.blueColor,
                                  child: const SvgIcon(
                                      height: 25,
                                      icon: AssetsStrings.send,
                                      color: Colors.white)),
                              8.verticalSpace,
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: widget.isShops
                                    ? Colors.black
                                    : ColorManager.blueColor,
                                child: const SvgIcon(
                                  height: 25,
                                  icon: AssetsStrings.phone,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 24.h),
                      widget.isResidential
                          ? SweetNavBar(
                              backgroundColor: Colors.white,
                              showSelectedLabels: true,
                              showUnselectedLabels: true,
                              currentIndex: cIndex,
                              items: [
                                SweetNavBarItem(
                                  isGradient: false,
                                  sweetActive: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: ColorManager.blueColor,
                                      child: const SvgIcon(
                                          height: 23,
                                          icon: AssetsStrings.bath,
                                          color: Colors.white)),
                                  sweetIcon: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: ColorManager.blueColor,
                                      child: const SvgIcon(
                                          height: 23,
                                          icon: AssetsStrings.bath,
                                          color: Colors.white)),
                                  sweetLabel: 'BathRoom',
                                ),
                                SweetNavBarItem(
                                  isGradient: false,
                                  sweetActive: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: ColorManager.blueColor,
                                      child: const SvgIcon(
                                          height: 23,
                                          icon: AssetsStrings.bed,
                                          color: Colors.white)),
                                  sweetIcon: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: ColorManager.blueColor,
                                      child: const SvgIcon(
                                        height: 23,
                                        icon: AssetsStrings.bed,
                                        color: Colors.white,
                                      )),
                                  sweetLabel: 'Office',
                                ),
                                SweetNavBarItem(
                                  isGradient: false,
                                  sweetActive: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: ColorManager.blueColor,
                                      child: const SvgIcon(
                                          height: 23,
                                          icon: AssetsStrings.car,
                                          color: Colors.white)),
                                  sweetIcon: CircleAvatar(
                                    radius: 26,
                                    backgroundColor: ColorManager.blueColor,
                                    child: const SvgIcon(
                                      height: 23,
                                      icon: AssetsStrings.car,
                                      color: Colors.white,
                                    ),
                                  ),
                                  sweetLabel: 'Parking ',
                                ),
                                SweetNavBarItem(
                                  isGradient: false,
                                  sweetActive: CircleAvatar(
                                    radius: 26,
                                    backgroundColor: ColorManager.blueColor,
                                    child: const SvgIcon(
                                      height: 18,
                                      icon: AssetsStrings.gym,
                                      color: Colors.white,
                                    ),
                                  ),
                                  sweetIcon: CircleAvatar(
                                    radius: 26,
                                    backgroundColor: ColorManager.blueColor,
                                    child: const SvgIcon(
                                      height: 18,
                                      icon: AssetsStrings.gym,
                                      color: Colors.white,
                                    ),
                                  ),
                                  sweetLabel: 'Gym ',
                                )
                              ],
                              onTap: (index) {
                                setState(() {
                                  cIndex = index;
                                });
                              },
                            )
                          : widget.isShops
                              ? const SizedBox.shrink()
                              : SweetNavBar(
                                  backgroundColor: Colors.white,
                                  showSelectedLabels: true,
                                  showUnselectedLabels: true,
                                  currentIndex: cIndex,
                                  items: [
                                    SweetNavBarItem(
                                      isGradient: false,
                                      sweetActive: CircleAvatar(
                                          radius: 26,
                                          backgroundColor:
                                              ColorManager.blueColor,
                                          child: const SvgIcon(
                                              height: 23,
                                              icon: AssetsStrings.bath,
                                              color: Colors.white)),
                                      sweetIcon: CircleAvatar(
                                        radius: 26,
                                        backgroundColor: ColorManager.blueColor,
                                        child: const SvgIcon(
                                          height: 23,
                                          icon: AssetsStrings.bath,
                                          color: Colors.white,
                                        ),
                                      ),
                                      sweetLabel: 'BathRoom',
                                    ),
                                    SweetNavBarItem(
                                      isGradient: false,
                                      sweetActive: CircleAvatar(
                                          radius: 26,
                                          backgroundColor:
                                              ColorManager.blueColor,
                                          child: const SvgIcon(
                                              height: 23,
                                              icon: AssetsStrings.bed,
                                              color: Colors.white)),
                                      sweetIcon: CircleAvatar(
                                        radius: 26,
                                        backgroundColor: ColorManager.blueColor,
                                        child: const SvgIcon(
                                          height: 23,
                                          icon: AssetsStrings.bed,
                                          color: Colors.white,
                                        ),
                                      ),
                                      sweetLabel: 'Office',
                                    ),
                                    SweetNavBarItem(
                                      isGradient: false,
                                      sweetActive: CircleAvatar(
                                        radius: 26,
                                        backgroundColor: ColorManager.blueColor,
                                        child: const SvgIcon(
                                          height: 23,
                                          icon: AssetsStrings.car,
                                          color: Colors.white,
                                        ),
                                      ),
                                      sweetIcon: CircleAvatar(
                                        radius: 26,
                                        backgroundColor: ColorManager.blueColor,
                                        child: const SvgIcon(
                                          height: 23,
                                          icon: AssetsStrings.car,
                                          color: Colors.white,
                                        ),
                                      ),
                                      sweetLabel: 'Parking ',
                                    ),
                                  ],
                                  onTap: (index) {
                                    setState(() {
                                      cIndex = index;
                                    });
                                  },
                                ),
                    ],
                  ),
                )
              ]);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            //   return state is TakeLookSuccess?

            //  :const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
