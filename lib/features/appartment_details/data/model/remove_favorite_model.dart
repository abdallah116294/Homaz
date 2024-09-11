class RemoveFavoriteModel {
    RemoveFavoriteModel({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final List<dynamic> data;

    factory RemoveFavoriteModel.fromJson(Map<String, dynamic> json){ 
        return RemoveFavoriteModel(
            result: json["result"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
        );
    }

}
