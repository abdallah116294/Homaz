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
import 'package:homez/features/appartment_details/cubit/appartment_details_cubit.dart';

class HomeScreenView extends StatefulWidget  {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView>  with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
     super.build(context);
    return BlocProvider(
      create: (context) => di.sl<HomeCubit>(),
      child: const HomeScreenBody(),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody>with AutomaticKeepAliveClientMixin {
 

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    super.build(context);
    return BlocProvider(
      create: (context) => di.sl<HomeCubit>()..getHomeData(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical:  screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
           SizedBox(height: screenHeight * 0.02),
            Align(
              alignment: context.read<AppCubit>().getAlignment(),
              child: CustomText(
                text: "Homz",
                color: ColorManager.white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.08,
              ),
            ),
           // 5.verticalSpace,
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
                      fontSize: screenWidth * 0.045,
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
                                  "${categories.name}",style: TextStyle(fontSize: screenWidth * 0.04)
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
                      BlocProvider(create:(context)=>di.sl<AppartmentDetailsCubit>() ,child:MainTabsWithBody(homeData: homedata),),
                      //MainTabsWithBody(homeData: homedata),
                      DefaultTabController(
                        length: homedata.categories.length,
                        child: TabBarWidget(
                          tabs: List.generate(
                            homedata.categories.length,
                            (index) {
                              final categories = homedata.categories[index];
                              return Text(
                                "${categories.name}",style: TextStyle(fontSize: screenWidth * 0.04),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
