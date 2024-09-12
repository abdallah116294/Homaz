import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/appartment_details/data/model/remove_favorite_model.dart';
import 'package:homez/features/saved/data/repo/favorite_repo.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({required this.favoriteRepo}) : super(FavoriteInitial());
  FavoriteRepo favoriteRepo;
  int _currentPage = 1;
  bool _hasMore = true;
  List<Datum> _apartments = [];
  Future<void> removFromFavoirte({required int id}) async {
    emit(RemoveFromFavoriteLoading());
    try {
      final response = await favoriteRepo.removeFavorite(apartmentId: id);
      response.fold((l) => emit(RemoveFromFavoriteFailedFav()),
          (r) => emit(RemoveFromFavoriteSuccessFav(removeFavoriteModel: r)));
    } catch (e) {
      emit(RemoveFromFavoriteFailedFav());
    }
  }

  Future<void> fetchFavoriteData({bool isLoadMore = false}) async {
    if (!_hasMore && isLoadMore) return; // If no more data, don't load more

    if (!isLoadMore) {
      emit(GetFavoriteLoading()); // Show loading only for initial fetch
    } else {
      final currentState = state;
      if (currentState is GetFavoriteSuccess) {
        emit(GetFavoriteSuccess(
          apartments: currentState.apartments,
          hasMore: _hasMore,
          isLoadingMore: true, // Indicate that more data is being loaded
        ));
      }
    }

    final response = await favoriteRepo.getFavoriteData(
        page: _currentPage); // Pass page number

    response.fold(
      (failure) => emit(GetFavoriteFailed(failure.errMessage)),
      (favoriteModel) {
        final newApartments = favoriteModel.data?.apartment?.data ?? [];
        _hasMore = favoriteModel.data?.apartment?.meta?.currentPage !=
            favoriteModel.data?.apartment?.meta?.lastPage;

        if (isLoadMore) {
          _apartments.addAll(newApartments); // Append new data for pagination
        } else {
          _apartments = newApartments; // Set new data on initial load
        }

        _currentPage++;

        emit(GetFavoriteSuccess(
          apartments: _apartments,
          hasMore: _hasMore,
          isLoadingMore: false,
        ));
      },
    );
  }
}
