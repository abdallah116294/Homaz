import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
import 'package:homez/features/search/search_filter_view.dart';
import 'package:homez/injection_container.dart' as di;

class ModalBottomSheet {
  static void searchFilter(
    BuildContext context,
    TextEditingController searchController,
  ) {
    showModalBottomSheet(
        //   barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        isDismissible: false,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => di.sl<SearchCubit>(),
            child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                            decoration: BoxDecoration(
                              color: ColorManager.bgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 428.w,
                            height: 800.h,
                            padding: const EdgeInsets.all(20),
                            child: SearchFilterView(searchController: searchController,)
                            ),
                      ),
                    ),
          );
        });
  }
}
