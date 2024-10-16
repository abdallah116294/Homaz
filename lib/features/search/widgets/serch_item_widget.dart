import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
import 'package:homez/features/search/data/models/search_result_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SearchItemWidget extends StatefulWidget {
  const SearchItemWidget({super.key, required this.data,required this.oTap});
  final Datum data;
  final VoidCallback oTap;
  @override
  State<SearchItemWidget> createState() => _SearchItemWidgetState();
}

class _SearchItemWidgetState extends State<SearchItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 146.h,
          width: 340.w,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              PageView(
                  controller: context.read<SearchCubit>().pageController,
                  onPageChanged: (index) {
                    setState(() {
                      context.read<SearchCubit>().currentPage = index;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      widget.data.images.length,
                      (index) => Container(
                            width: 340.w,
                            height: 340.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.data.images[index].toString()),
                                    fit: BoxFit.fill)),
                          ))),
              Positioned(
                top: 10,
                right: 22,
                child: GestureDetector(
                  onTap: widget.oTap,
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                        color: ColorManager.bgColor, shape: BoxShape.circle),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SvgIcon(
                        color: ColorManager.white,
                        icon: AssetsStrings.favorite,
                        height: 24.h,
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return Positioned(
                    bottom: 20.0,
                    left: 160,
                    child: SmoothPageIndicator(
                      onDotClicked: (index) {
                        if (index < widget.data.images.length) {
                          context.read<SearchCubit>().scrollToNextPage();
                        } else {
                          context.read<SearchCubit>().scrollToPreviousPage();
                        }
                      },
                      controller: context
                          .read<SearchCubit>()
                          .pageController, // PageController for PageView
                      count: widget.data.images
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
        SizedBox(
          height: 10.h,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                  text:
                      widget.data.name.toString().split(' ').take(4).join(' '),
                  color: ColorManager.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp),
              CustomText(
                  text: "\$${widget.data.buyPrice}",
                  color: ColorManager.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
            ],
          ),
        )
      ],
    );
  }
}
