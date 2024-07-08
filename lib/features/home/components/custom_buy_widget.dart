import 'package:flutter/material.dart';
import 'package:homez/core/theming/assets.dart';
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
            height: width,
            width: width * 0.95,
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                List<Widget> cards = [];

                for (int i = 0; i < pages.length; i++) {
                  double currentPageValue = i - _currentPage;
                  bool pageLocation = currentPageValue > 0;

                  double start = 20 +
                      ((boxConstraints.maxWidth - width * 0.75) -
                          ((boxConstraints.maxWidth - width * 0.75) / 2) *
                              -currentPageValue *
                              (pageLocation ? 9 : 1));

                  var customizableCard = Positioned.directional(
                    top: 20 + 30 * max(-currentPageValue, 0.0),
                    bottom: 20 + 30 * max(-currentPageValue, 0.0),
                    start: start,
                    textDirection: TextDirection.ltr,
                    child: Container(
                      height: width * 0.67,
                      width: width * 0.67,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          pages[i].image!,
                          fit: BoxFit.cover,
                        ),
                      ),
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
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              controller: _pageController,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
