import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/search/data/models/data_search.dart';
import 'package:homez/features/search/data/models/recent_search_model.dart';
import 'package:homez/features/search/data/models/search_result_model.dart';
import 'package:homez/features/search/data/repo/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.searchRepo}) : super(SearchInitial());
  SearchRepo searchRepo;
  RecentSearchModel? recentSearchModel;
  SearchResultModel? searchResultModel;
  PageController pageController = PageController();
  int currentPage = 0;
  void scrollToNextPage() {
    if (currentPage < 3) {
      // Assuming 4 images, update this number based on total images
      pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToPreviousPage() {
    if (currentPage > 0) {
      pageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> fetchRecentSearch() async {
    emit(GetRecentSearchLoading());
    try {
      final response = await searchRepo.getRecentSearch();
      response.fold((l) => emit(GetRecentSearchFailed()), (r) {
        recentSearchModel = r;
        emit(GetRecentSearchSuccess(recentSearchModel: r));
      });
    } catch (e) {
      emit(GetRecentSearchFailed());
    }
  }

  Future<void> deleteRecentSearchById({required int id}) async {
    emit(DeleteRecentSearchByIdLoading());
    try {
      final response = await searchRepo.deleteRecentSearchById(id: id);
      response.fold((l) => emit(DeleteRecentSearchByIdFailed()),
          (r) => emit(DeleteRecentSearchByIdSuccess(recentSearchModel: r)));
    } catch (e) {
      emit(DeleteRecentSearchByIdFailed());
    }
  }

  Future<void> defulateSearch({required String keyword}) async {
    emit(DefaultSearchLoading());
    try {
      final response = await searchRepo.defaultSearch(keyword: keyword);
      response.fold((l) => emit(DefaultSearchFailed()),
          (r) => emit(DefaultSearchSuccess(searchResultModel: r)));
    } catch (e) {
      emit(DefaultSearchFailed());
    }
  }

  Future<void> addToFavorite({required int id}) async {
    try {
      emit(AddToFavoriteLoading());
      final response = await searchRepo.addToFavoirte(apartmentId: id);
      response.fold((l) => emit(AddToFavoriteFailed()),
          (r) => emit(AddToFavoriteSuccess(favoriteModel: r)));
    } catch (e) {
      emit(AddToFavoriteFailed());
    }
  }

  Future<void> FilterSearch(
      {String? type,
      int? has_furnished,
      List<int>? category_ids,
      List<int>? amenities_id,
      double? min_price,
      double? max_price,
      required String search_string}) async {
    emit(GetSearchWithFilterLoading());
    try {
      final response = await searchRepo.searchWithFilter(
        type: type,
        has_furnished: has_furnished,
        category_ids: category_ids,
        amenities_id: amenities_id,
        min_price: min_price,
        max_price: max_price,
        search_string: search_string,
      );
      response.fold((l) {
        if(l is ServerFailure){
          log("Server Failure"+l.errMessage.toString());
        }else{
          log("Server Failure"+l.errMessage.toString());
        }
        emit(GetSearchWithFilterFailed());
      }, (r) {
        log("Success" + r.toString());
        emit(GetSearchWithFilterSuccess(searchResultModel: r));
      });
    } catch (e) {
      emit(GetSearchWithFilterFailed());
    }
  }

  Future<void> getDataInSearch() async {
    emit(GetDataInSearchLoading());
    try {
      final response = await searchRepo.getDataInSearch();
      response.fold((l) => emit(GetDataInSearchFailed()),
          (r) => emit(GetDataInSearchSuccess(dataInSearch: r)));
    } catch (e) {
      emit(GetDataInSearchFailed());
    }
  }
}
