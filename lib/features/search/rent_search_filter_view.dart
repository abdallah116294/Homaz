import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
import 'package:homez/features/search/widgets/amenities_widget.dart';
import 'package:homez/features/search/widgets/badrooms_widget.dart';
import 'package:homez/features/search/widgets/bathroom_filter.dart';
import 'package:homez/features/search/widgets/furnshied_fliter_widget.dart';
import 'package:homez/features/search/widgets/price_range_widget.dart';
import 'package:homez/features/search/widgets/property_type_widget.dart';
import 'package:homez/injection_container.dart' as di;

class RentSearchFilterView extends StatefulWidget {
  const RentSearchFilterView(
      {super.key, required this.searchString, required this.index});
  final String searchString;
  final int index;
  @override
  State<RentSearchFilterView> createState() => _RentSearchFilterViewState();
}

class _RentSearchFilterViewState extends State<RentSearchFilterView> {
  int? _selectedPropertyTypeIndex;
  int? _badroomsNumberSelected;
  int? hasFurnishedSelected;
  String? bathroomsSelectedValue;
  int? bathroomsSelectedIndex;
  int? amentiasSelected;
  double? minPrice, maxPrice;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SearchCubit>()..getDataInSearch(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          if (state is GetSearchWithFilterSuccess) {
            if (state.searchResultModel.data!.apartment!.data.length == 0) {
              showMessage(message: "No Result Found", color: ColorManager.red);
            } else {
              context.pushName(AppRoutes.searchresultScreen, arguments: {
                "apartment": state.searchResultModel.data!.apartment!
              });
              //context.pushName(AppRoutes.searchScreenView,arguments: widget.searchString);
              // MagicRouter.navigateTo(
              //     page: BlocProvider(
              //   create: (context) => di.sl<SearchCubit>(),
              //   child: SearchScreenViews(searchString: widget.searchString),
              // ));
            }
          }
        },
        builder: (context, state) {
          return BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return state is GetDataInSearchSuccess
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            PropertyTypeWidget(
                              categories: state.dataInSearch.data!,
                              onSelectionChanged: (int index) {
                                setState(() {
                                  _selectedPropertyTypeIndex = index;
                                });
                              },
                            ),
                            SizedBox(height: 20.h),
                            BadRoomsFilterWidget(
                              onSelectionChanged: (int index) {
                                setState(() {
                                  _badroomsNumberSelected = index;
                                });
                              },
                            ),
                            SizedBox(height: 20.h),
                            BathroomFilterWidget(
                              onSelectionChanged: (int index, String value) {
                                setState(() {
                                  bathroomsSelectedIndex = index;
                                  bathroomsSelectedValue = value;
                                });
                              },
                            ),
                            SizedBox(height: 20.h),
                            FurnishedFilterWidget(
                              onSelectionChanged: (int index) {
                                setState(() {
                                  hasFurnishedSelected = index;
                                });
                              },
                            ),
                            SizedBox(height: 20.h),
                            AmenitiesFilterWidget(
                              amenities: state.dataInSearch.data!,
                              onSelectionChanged: (int index) {
                                setState(() {
                                  amentiasSelected = index;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            PriceRangeWidget(
                              onRangeSelected: (double min, double max) {
                                setState(() {
                                  minPrice = min;
                                  maxPrice = max;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomElevated(
                                text: 'Show All Results',
                                press: () {
                                  log(widget.searchString.toString());
                                  if (widget.index == 1) {
                                    log(hasFurnishedSelected.toString());
                                    // log("Range Price Values $selectedRangeValues");
                                    List<int>? amenitiesIds =
                                        amentiasSelected != null
                                            ? [amentiasSelected!]
                                            : null;
                                    List<int>? categoryIds =
                                        _selectedPropertyTypeIndex != null
                                            ? [_selectedPropertyTypeIndex!]
                                            : null;
                                    context
                                        .read<SearchCubit>()
                                        .FilterSearch(
                                          search_string: widget.searchString,
                                          category_ids: categoryIds,
                                          amenities_id: amenitiesIds,
                                          has_furnished: hasFurnishedSelected,
                                          max_price: maxPrice,
                                          min_price: minPrice,
                                          type: "rent",
                                        )
                                        .then((value) {
                                      context
                                          .read<SearchCubit>()
                                          .getDataInSearch();
                                    });
                                  } else {
                                    log(hasFurnishedSelected.toString());
                                    // log("Range Price Values $selectedRangeValues");
                                    List<int>? amenitiesIds =
                                        amentiasSelected != null
                                            ? [amentiasSelected!]
                                            : null;
                                    List<int>? categoryIds =
                                        _selectedPropertyTypeIndex != null
                                            ? [_selectedPropertyTypeIndex!]
                                            : null;
                                    context
                                        .read<SearchCubit>()
                                        .FilterSearch(
                                          search_string: widget.searchString,
                                          category_ids: categoryIds,
                                          amenities_id: amenitiesIds,
                                          has_furnished: hasFurnishedSelected,
                                          max_price: maxPrice,
                                          min_price: minPrice,
                                          type: "buy",
                                        )
                                        .then((value) {
                                      context
                                          .read<SearchCubit>()
                                          .getDataInSearch();
                                    });
                                  }
                                },
                                btnColor: ColorManager.mainColor)
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          );
        },
      ),
    );
  }
}
