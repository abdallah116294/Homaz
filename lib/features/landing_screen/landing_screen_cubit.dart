import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/chat/message_screen.dart';
import 'package:homez/features/home/home_cubit.dart';
import 'package:homez/features/home/home_view.dart';
import 'package:homez/features/profile/profile_view.dart';
import 'package:homez/features/saved/saved_view.dart';
import 'package:homez/features/search/search_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:homez/injection_container.dart' as di;

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
        icon: AssetsStrings.search,
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
    BlocProvider(
      create: (context) =>di.sl<HomeCubit>()..getHomeData(),
      child: const HomeScreenView(),
    ),
    const SearchScreenViews(),
    const SavedView(),
    const MessagesScreen(),
    const ProfileView()
  ];

  Widget get getCurrentView => screens[currentIndex];
}
