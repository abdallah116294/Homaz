import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/app/cubit/app_cubit.dart';
import 'package:homez/features/home/components/tab_bar_widget.dart';
import 'package:homez/injection_container.dart' as di;
import 'components/main_tabs_with_body.dart';
import 'home_cubit.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HomeCubit>()..getHomeData(),
      child: const HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);

    return BlocProvider(
      create: (context) => di.sl<HomeCubit>()..getHomeData(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            16.verticalSpace,
            Align(
              alignment: context.read<AppCubit>().getAlignment(),
              child: CustomText(
                text: "Homz",
                color: ColorManager.white,
                fontWeight: FontWeight.w700,
                fontSize: 32.sp,
              ),
            ),
            6.verticalSpace,
            Expanded(
              child: BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  if (state is HomeDataLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.mainColor,
                      ),
                    );
                  } else if (state is HomeDataFailedState) {
                    return CustomText(
                      text: state.msg,
                      color: ColorManager.red,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    );
                  } else if (state is HomeDataSuccessState) {
                    return ListView(
                      children: [
                        MainTabsWithBody(homeData: state.homeData.data!),
                        DefaultTabController(
                          length: state.homeData.data!.categories.length,
                          child: TabBarWidget(
                            tabs: List.generate(
                              state.homeData.data!.categories.length,
                              (index) {
                                final categories =
                                    state.homeData.data!.categories[index];
                                return Text(
                                  "${categories.name}",
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  final homedata = cubit.homeData!.data!;
                  return ListView(
                    children: [
                      MainTabsWithBody(homeData: homedata),
                      DefaultTabController(
                        length: homedata.categories.length,
                        child: TabBarWidget(
                          tabs: List.generate(
                            homedata.categories.length,
                            (index) {
                              final categories = homedata.categories[index];
                              return Text(
                                "${categories.name}",
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                  // final homeData = cubit.homeData!.data!;
                  //   return ListView(
                  //     children: [
                  //       MainTabsWithBody(homeData: homeData),
                  //       DefaultTabController(
                  //         length: homeData.categories!.length,
                  //         child: TabBarWidget(
                  //           tabs: List.generate(
                  //             homeData.categories!.length,
                  //             (index) {
                  //               final categories = homeData.categories![index];
                  //               return Text(
                  //                 "${categories.name}",
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
