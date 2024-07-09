import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/circle_image.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/home/card_model.dart';

import 'dart:math';

class CustomBuyWidget extends StatefulWidget {
  const CustomBuyWidget({super.key});

  @override
  _CustomBuyWidgetState createState() => _CustomBuyWidgetState();
}

class _CustomBuyWidgetState extends State<CustomBuyWidget> {
  late PageController _pageController;
  double _currentPage = 10;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 10);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // Sample list of CardModel instances with image paths
    List<CardModel> pages = [
      CardModel(AssetsStrings.onBoarding1),
      CardModel(AssetsStrings.onBoarding2),
      CardModel(AssetsStrings.onBoarding3),
      CardModel(AssetsStrings.onBoarding1),
      CardModel(AssetsStrings.onBoarding2),
      CardModel(AssetsStrings.onBoarding3),
    ];

    return Center(
      child: Stack(
        children: [
          SizedBox(

            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                List<Widget> cards = [];

                for (int i = 0; i < pages.length; i++) {
                  double currentPageValue = i - _currentPage;
                  bool pageLocation = currentPageValue > 0;

                  double start = 50 +
                      ((boxConstraints.maxWidth - width * 0.75) -
                          ((boxConstraints.maxWidth - width * 0.75) / 2) *
                              -currentPageValue *
                              (pageLocation ? 9 : 1));

                  var customizableCard = Positioned.directional(
                    top: 24,
                    bottom: 24,
                    start: start,
                    textDirection: TextDirection.ltr,
                    child: Stack(
                      children: [
                        Container(
                          //height: width ,
                          width: width * 0.67,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              pages[i].image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 30,
                          top: 16,
                          child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black,
                              child: SvgIcon(
                                  icon: AssetsStrings.favorite,
                                  color: Colors.white)),
                        ),
                        Positioned(
                          left: 38,
                          bottom: 12,
                          child: Row(
                            children: [
                              SizedBox(
                                child: CustomElevated(
                                  borderRadius: 8.sp,
                                  text: "Take a Look ",
                                  press: () {},
                                  btnColor: ColorManager.mainColor,
                                ),
                                height: 38.h,
                                width: 141.w,
                              ),
                    8.horizontalSpace,
                    CircleAvatar(
                        radius: 20,
                        backgroundColor: ColorManager.blueColor,
                        child: SvgIcon(
                            icon: AssetsStrings.out,
                            color: Colors.white)),

                            ],
                          ),
                        )
                      ],
                    ),
                  );
                  cards.add(customizableCard);
                }
                return Stack(children: cards);
              },
            ),
          ),
          Positioned.fill(
            child: PageView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              controller: _pageController,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
