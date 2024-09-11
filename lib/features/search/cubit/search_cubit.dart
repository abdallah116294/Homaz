import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/features/search/data/models/recent_search_model.dart';
import 'package:homez/features/search/data/repo/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.searchRepo}) : super(SearchInitial());
  SearchRepo searchRepo;
  Future<void> fetchRecentSearch() async {
    emit(GetRecentSearchLoading());
    try {
      final response = await searchRepo.getRecentSearch();
      response.fold((l) => emit(GetRecentSearchFailed()),
          (r) => emit(GetRecentSearchSuccess(recentSearchModel: r)));
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
}
