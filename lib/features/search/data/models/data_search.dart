class DataInSearch {
    DataInSearch({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory DataInSearch.fromJson(Map<String, dynamic> json){ 
        return DataInSearch(
            result: json["result"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.categories,
        required this.amenities,
    });

    final List<Amenity> categories;
    final List<Amenity> amenities;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            categories: json["categories"] == null ? [] : List<Amenity>.from(json["categories"]!.map((x) => Amenity.fromJson(x))),
            amenities: json["amenities"] == null ? [] : List<Amenity>.from(json["amenities"]!.map((x) => Amenity.fromJson(x))),
        );
    }

}

class Amenity {
    Amenity({
        required this.id,
        required this.name,
    });

    final int? id;
    final String? name;

    factory Amenity.fromJson(Map<String, dynamic> json){ 
        return Amenity(
            id: json["id"],
            name: json["name"],
        );
    }

}
