import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/chat/message_screen.dart';
import 'package:homez/features/favorite/fav_views.dart';
import 'package:homez/features/home/home_view.dart';
import 'package:homez/features/search/search_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

part 'landing_screen_state.dart';

class LandingScreenCubit extends Cubit<LandingScreenState> {
  LandingScreenCubit() : super(LandingScreenInitial());
  int currentIndex = 0;

  void changeNavigationBottom(index) {
    currentIndex = index;
    emit(ChangeBottomNavigationState());
  }

  List<SalomonBottomBarItem> bottomNavigationItems = [
    SalomonBottomBarItem(
      icon: SvgIcon(
        icon: AssetsStrings.home,
        color: ColorManager.white,
      ),
      title: const Text(
        "Home",
        style: TextStyle(color: Colors.white),
      ),
      selectedColor: ColorManager.blueColor,
    ),

    /// Likes
    SalomonBottomBarItem(
      icon: SvgIcon(
        icon: AssetsStrings.searchNormal,
        color: ColorManager.white,
      ),
      title: const Text(
        "Search",
        style: TextStyle(color: Colors.white),
      ),
      selectedColor: ColorManager.blueColor,
    ),

    /// Search
    SalomonBottomBarItem(
      icon: SvgIcon(
        icon: AssetsStrings.heart,
        color: ColorManager.white,
      ),
      title: const Text(
        "Saved",
        style: TextStyle(color: Colors.white),
      ),
      selectedColor: ColorManager.blueColor,
    ),
    SalomonBottomBarItem(
      icon: SvgIcon(
        icon: AssetsStrings.chat,
        color: ColorManager.white,
      ),
      title: const Text(
        "Chat",
        style: TextStyle(color: Colors.white),
      ),
      selectedColor: ColorManager.blueColor,
    ),

    /// Profile
    SalomonBottomBarItem(
      icon: SvgIcon(
        icon: AssetsStrings.profile,
        color: ColorManager.white,
      ),
      title: const Text(
        "Profile",
        style: TextStyle(color: Colors.white),
      ),
      selectedColor: ColorManager.blueColor,
    ),
  ];
  List<Widget> screens = [
    const HomeScreenView(),
    const SearchScreenViews(),
    const MesssageScreenViews(),
    const FavScreenView(),
    const HomeScreenView()
  ];

  Widget get getCurrentView => screens[currentIndex];
}
