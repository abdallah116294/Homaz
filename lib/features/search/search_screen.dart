import 'package:flutter/material.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/search_text_field.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/features/appartment_details/screen/appartment_details.dart';
import 'package:homez/features/landing_screen/landing_screen_cubit.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
import 'package:homez/features/search/default_search_view.dart';
import 'package:homez/features/search/recent_search_view.dart';
import 'package:homez/features/search/search_screen_with_filter.dart';
import 'package:homez/features/search/widgets/model_bottom_sheet.dart';
import 'package:homez/features/search/widgets/serch_item_widget.dart';
import 'package:homez/injection_container.dart' as di;

class SearchScreenViews extends StatefulWidget {
  SearchScreenViews({super.key, this.searchString});
  String? searchString;
  @override
  State<SearchScreenViews> createState() => _SearchScreenViewsState();
}

class _SearchScreenViewsState extends State<SearchScreenViews> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
  
    if (widget.searchString == null) {
      return DefaultSearchView();
    } else {
      return SearchScreenWithFilter(searchString: widget.searchString,);
    }
  }
}
