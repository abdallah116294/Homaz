import 'package:flutter/material.dart';
import 'package:homez/core/theming/colors.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
    required this.tabs,
    required this.isScrollable,
    required this.pages,
  });

  final List<Widget> tabs;
  final List<Widget> pages;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: pages,
          ),
        ),
        Container(
          height: 43,
          child: TabBar(
            indicatorColor: Colors.transparent,
            labelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 14,color: Colors.white),
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            isScrollable: isScrollable,
            //labelPadding: const EdgeInsets.symmetric(horizontal: 20),
            unselectedLabelStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            tabs: tabs,
          ),
        ),

      ],
    );
  }
}
