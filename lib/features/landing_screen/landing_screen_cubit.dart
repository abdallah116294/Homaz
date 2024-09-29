import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/chat/cubit/chat_cubit.dart';
import 'package:homez/features/chat/message_screen.dart';
import 'package:homez/features/home/home_cubit.dart';
import 'package:homez/features/home/home_view.dart';
import 'package:homez/features/profile/profile_view.dart';
import 'package:homez/features/saved/cubit/favorite_cubit.dart';
import 'package:homez/features/saved/saved_view.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
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

  List<SalomonBottomBarItem> buildBottomNavigationItems(BuildContext context) {
    return [
      SalomonBottomBarItem(
        icon: SvgIcon(
          icon: AssetsStrings.home,
          color: ColorManager.white,
        ),
        title: Text(
          context.translate(LangKeys.home), // Use context.translate here
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        selectedColor: ColorManager.blueColor,
      ),
      SalomonBottomBarItem(
        icon: SvgIcon(
          icon: AssetsStrings.search,
          color: ColorManager.white,
        ),
        title: Text(
          context.translate(LangKeys.search), // Translation for "Search"
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        selectedColor: ColorManager.blueColor,
      ),
      SalomonBottomBarItem(
        icon: SvgIcon(
          icon: AssetsStrings.heart,
          color: ColorManager.white,
        ),
        title: Text(
          context.translate(LangKeys.saved), // Translation for "Saved"
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        selectedColor: ColorManager.blueColor,
      ),
      SalomonBottomBarItem(
        icon: SvgIcon(
          icon: AssetsStrings.chat,
          color: ColorManager.white,
        ),
        title: Text(
          context.translate(LangKeys.message), // Translation for "Chat"
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        selectedColor: ColorManager.blueColor,
      ),
      SalomonBottomBarItem(
        icon: SvgIcon(
          icon: AssetsStrings.profile,
          color: ColorManager.white,
        ),
        title: Text(
          context.translate(LangKeys.profile), // Translation for "Profile"
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        selectedColor: ColorManager.blueColor,
      ),
    ];
  }

  List<Widget> screens = [
    BlocProvider(
      create: (context) => di.sl<HomeCubit>()..getHomeData(),
      child: const HomeScreenView(),
    ),
    BlocProvider(
      create: (context) => di.sl<SearchCubit>()..fetchRecentSearch(),
      child: SearchScreenViews(),
    ),
    BlocProvider(
      create: (context) => di.sl<FavoriteCubit>()..fetchFavoriteData(),
      child: const SavedView(),
    ),
    BlocProvider(
      create: (context) => di
     .sl<ChatCubit>(),
      child: const MessagesScreen(),
    ),
    const ProfileView()
  ];

  Widget get getCurrentView => screens[currentIndex];
}
