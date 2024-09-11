part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}
class GetRecentSearchLoading extends SearchState {}
class GetRecentSearchSuccess extends SearchState {
  final RecentSearchModel recentSearchModel;
  const GetRecentSearchSuccess({required this.recentSearchModel});
}
class GetRecentSearchFailed extends SearchState {}
class DeleteRecentSearchByIdLoading extends SearchState {}
class DeleteRecentSearchByIdSuccess extends SearchState {
  final RecentSearchModel recentSearchModel;
  const DeleteRecentSearchByIdSuccess({required this.recentSearchModel});
}
class DeleteRecentSearchByIdFailed extends SearchState {}