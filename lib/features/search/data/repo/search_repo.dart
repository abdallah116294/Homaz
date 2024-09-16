import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/search/data/models/data_search.dart';
import 'package:homez/features/search/data/models/recent_search_model.dart';
import 'package:homez/features/search/data/models/search_result_model.dart';

class SearchRepo {
  ApiConsumer apiConsumer;
  SearchRepo({required this.apiConsumer});
  Future<Either<Failure, RecentSearchModel>> getRecentSearch() async {
    try {
      final response = await apiConsumer.get(ApiConstants.recentSearch);
      if (response.statusCode == 200) {
        return Right(RecentSearchModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, RecentSearchModel>> deleteRecentSearchById(
      {required int id}) async {
    try {
      final response = await apiConsumer
          .post(ApiConstants.deleteRecentSearchById + id.toString());
      if (response.statusCode == 200) {
        return Right(RecentSearchModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, SearchResultModel>> defaultSearch(
      {required String keyword}) async {
    try {
      final response =
          await apiConsumer.get(ApiConstants.search, queryParameters: {
        "type": "rent",
        "search_string": keyword,
      });
      if (response.statusCode == 200) {
        return Right(SearchResultModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, FavoriteModel>> addToFavoirte(
      {required int apartmentId}) async {
    try {
      final response = await apiConsumer
          .post('${ApiConstants.addOrRemoveFavoirte}$apartmentId');
      if (response.statusCode == 200) {
        return Right(FavoriteModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  //Filter Search
  Future<Either<Failure, SearchResultModel>> searchWithFilter({
    String? type,
    int? has_furnished,
    List<int>? category_ids,
    List<int>? amenities_id,
    double? min_price,
    double? max_price,
    required String search_string,
  }) async {
    try {
      var queryParameters = {
        'type': type,
        'has_furnished': has_furnished,
        'min_price': min_price,
        'max_price': max_price,
        'search_string': search_string,
      };
      if (amenities_id != null) {
        for (int i = 0; i < amenities_id.length; i++) {
          queryParameters['amenities_ids[$i]'] = amenities_id[i].toString();
        }
      }
      if (category_ids != null) {
        for (int i = 0; i < category_ids.length; i++) {
          queryParameters['category_ids[$i]'] = category_ids[i].toString();
        }
      }

      queryParameters.removeWhere((key, value) => value == null);
      log("Query Parameters:$queryParameters");
      final response = await apiConsumer.get(ApiConstants.search,
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return Right(SearchResultModel.fromJson(response.data
        ));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      } else {
        return Left(ServerFailure('An unknown error: $e'));
      }
    }
  }

  // get Data in search
  Future<Either<Failure, DataInSearch>> getDataInSearch() async {
    try {
      final response = await apiConsumer.get(ApiConstants.getDataInSearch);
      if (response.statusCode == 200) {
        return Right(DataInSearch.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure(e.errMessage.toString()));
      } else {
        return Left(ServerFailure('An unknown error: $e'));
      }
    }
  }
}
