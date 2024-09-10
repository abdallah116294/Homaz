import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/appartment_details/cubit/appartment_details_cubit.dart';
import 'package:homez/features/take_look/data/model/take_look_model.dart';
import 'package:homez/features/take_look/take_look_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:homez/injection_container.dart' as di;

class StackedImageSlider extends StatefulWidget {
  final TakeLookData takeLookData;

  const StackedImageSlider({
    super.key,
    required this.takeLookData,
  });
  @override
  _StackedImageSliderState createState() => _StackedImageSliderState();
}

class _StackedImageSliderState extends State<StackedImageSlider> {
  @override
  void initState() {
    super.initState();
    context.read<AppartmentDetailsCubit>().pageController.addListener(() {
      setState(() {
        context.read<AppartmentDetailsCubit>().currentPage =
            context.read<AppartmentDetailsCubit>().pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AppartmentDetailsCubit>(),
      child: Container(
        height: 340.h,
        child: Stack(
          children: [
            PageView(
                controller:
                    context.read<AppartmentDetailsCubit>().pageController,
                onPageChanged: (index) {
                  setState(() {
                    context.read<AppartmentDetailsCubit>().currentPage = index;
                  });
                },
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    widget.takeLookData.data!.apartments!.images.length,
                    (index) => Container(
                          width: 340.w,
                          height: 340.h,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              image: DecorationImage(
                                  image: NetworkImage(widget.takeLookData.data!
                                      .apartments!.images[index]
                                      .toString()),
                                  fit: BoxFit.fill)),
                        ))),
            Positioned(
              top: 10,
              //right: 2,
              left: 22,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.white,
                  backgroundColor: ColorManager.mainColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: CustomText(
                    text: "Take a Look",
                    color: ColorManager.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 25.0,
              right: 22,
              child: CircleAvatar(
                  radius: 26,
                  backgroundColor: ColorManager.blueColor,
                  child: const SvgIcon(
                      height: 25,
                      icon: AssetsStrings.send,
                      color: Colors.white)),
            ),
            BlocBuilder<AppartmentDetailsCubit, AppartmentDetailsState>(
              builder: (context, state) {
                return Positioned(
                  bottom: 20.0,
                  left: 160,
                  child: SmoothPageIndicator(
                    onDotClicked: (index) {
                      if (index < widget.takeLookData.data!.apartments!.images
                        .length) {
                        context
                            .read<AppartmentDetailsCubit>()
                            .scrollToNextPage();
                      } else {
                        context
                            .read<AppartmentDetailsCubit>()
                            .scrollToPreviousPage();
                      }
                    },
                    controller: context
                        .read<AppartmentDetailsCubit>()
                        .pageController, // PageController for PageView
                    count: widget.takeLookData.data!.apartments!.images
                        .length, // Total number of pages (Change this to the total number of images)
                    effect: const WormEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey,
                      dotHeight: 8.0,
                      dotWidth: 8.0,
                      spacing: 6.0,
                    ), // Customize the appearance of dots here
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
