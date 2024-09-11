part of 'favorite_cubit.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}
class GetFavoriteLoading extends FavoriteState{}
class GetFavoriteSuccess extends FavoriteState{
     final List<Datum> apartments;
  final bool hasMore;
  final bool isLoadingMore;
  GetFavoriteSuccess({required this.apartments,required this.hasMore,required this.isLoadingMore});
}
class GetFavoriteFailed extends FavoriteState{
  final String message;
  GetFavoriteFailed(this.message);
}
class RemoveFromFavoriteLoading extends FavoriteState{}
class RemoveFromFavoriteSuccess extends FavoriteState{
  final RemoveFavoriteModel removeFavoriteModel;
  RemoveFromFavoriteSuccess({required this.removeFavoriteModel});
}
class RemoveFromFavoriteFailed extends FavoriteState{}

