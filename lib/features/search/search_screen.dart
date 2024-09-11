import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/circle_image.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/search_text_field.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
import 'package:homez/features/search/widgets/model_bottom_sheet.dart';
import 'package:homez/injection_container.dart' as di;

class SearchScreenViews extends StatefulWidget {
  const SearchScreenViews({super.key});

  @override
  State<SearchScreenViews> createState() => _SearchScreenViewsState();
}

class _SearchScreenViewsState extends State<SearchScreenViews> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => di.sl<SearchCubit>()..fetchRecentSearch(),
      child: Scaffold(
          backgroundColor: ColorManager.bgColor,
          body: SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: size.width * .7,
                        color: ColorManager.bgColor,
                        child: const SearchTextField(
                          hint: "Search",
                        )),
                    Center(
                      child: IconButton(
                          onPressed: () {
                            ModalBottomSheet.searchFilter(context);
                          },
                          icon: const Icon(Icons.filter_alt_outlined)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: ColorManager.grey11,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              text: 'History',
                              color: ColorManager.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          const SizedBox(height: 10),
                          BlocBuilder<SearchCubit, SearchState>(
                              builder: (context, state) {
                            if (state is GetRecentSearchLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is GetRecentSearchSuccess) {
                              final recentSearchModel = state.recentSearchModel;
                              return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {                                  
                                    return ListTile(
                                      trailing: IconButton(
                                          onPressed: () {
                                            context
                                                .read<SearchCubit>()
                                                .deleteRecentSearchById(
                                                    id: recentSearchModel
                                                        .data!
                                                        .recentSearchHistory[index]
                                                        .id!);
                                            context
                                                .read<SearchCubit>()
                                                .fetchRecentSearch();
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: ColorManager.white,
                                          )),
                                      title: CustomText(
                                          text: recentSearchModel
                                              .data!
                                              .recentSearchHistory[index]
                                              .keyword
                                              .toString(),
                                          color: ColorManager.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10,
                                      ),
                                  itemCount: recentSearchModel
                                      .data!.recentSearchHistory.length);
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          })
                        ]),
                  ),
                ),
              )
            ]),
          )),
    );
  }
}
