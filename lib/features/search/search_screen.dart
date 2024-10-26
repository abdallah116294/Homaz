import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
import 'package:homez/features/search/default_search_view.dart';
import 'package:homez/features/search/search_screen_with_filter.dart';
import 'package:homez/injection_container.dart' as di;

class SearchScreenViews extends StatefulWidget {
  SearchScreenViews({super.key, this.searchString});
  String? searchString;
  @override
  State<SearchScreenViews> createState() => _SearchScreenViewsState();
}

class _SearchScreenViewsState extends State<SearchScreenViews> with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.searchString == null) {
      return DefaultSearchView();
    } else {
      return BlocProvider(
        create: (context) => di.sl<SearchCubit>(),
        child: SearchScreenWithFilter(
          searchString: widget.searchString,
        ),
      );
    }
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
