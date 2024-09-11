class RecentSearchModel {
    RecentSearchModel({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory RecentSearchModel.fromJson(Map<String, dynamic> json){ 
        return RecentSearchModel(
            result: json["result"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.recentSearchHistory,
    });

    final List<RecentSearchHistory> recentSearchHistory;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            recentSearchHistory: json["Recent Search History"] == null ? [] : List<RecentSearchHistory>.from(json["Recent Search History"]!.map((x) => RecentSearchHistory.fromJson(x))),
        );
    }

}

class RecentSearchHistory {
    RecentSearchHistory({
        required this.id,
        required this.keyword,
    });

    final int? id;
    final String? keyword;

    factory RecentSearchHistory.fromJson(Map<String, dynamic> json){ 
        return RecentSearchHistory(
            id: json["id"],
            keyword: json["keyword"],
        );
    }

}
