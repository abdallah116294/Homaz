class TakeLookData {
    TakeLookData({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory TakeLookData.fromJson(Map<String, dynamic> json){ 
        return TakeLookData(
            result: json["result"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.apartments,
    });

    final Apartments? apartments;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            apartments: json["apartments"] == null ? null : Apartments.fromJson(json["apartments"]),
        );
    }

}

class Apartments {
    Apartments({
        required this.id,
        required this.images,
        required this.mainImage,
        required this.name,
        required this.description,
        required this.amenities,
        required this.contact,
        required this.rentPrice,
        required this.buyPrice,
        required this.numDaysOfRent,
    });

    final int? id;
    final List<String> images;
    final String? mainImage;
    final String? name;
    final String? description;
    final List<Amenity> amenities;
    final List<dynamic> contact;
    final int? rentPrice;
    final int? buyPrice;
    final int? numDaysOfRent;

    factory Apartments.fromJson(Map<String, dynamic> json){ 
        return Apartments(
            id: json["id"],
            images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
            mainImage: json["main_image"],
            name: json["name"],
            description: json["description"],
            amenities: json["amenities"] == null ? [] : List<Amenity>.from(json["amenities"]!.map((x) => Amenity.fromJson(x))),
            contact: json["contact"] == null ? [] : List<dynamic>.from(json["contact"]!.map((x) => x)),
            rentPrice: json["rent_price"],
            buyPrice: json["buy_price"],
            numDaysOfRent: json["num_days_of_rent"],
        );
    }

}

class Amenity {
    Amenity({
        required this.id,
        required this.name,
        required this.count,
    });

    final int? id;
    final String? name;
    final int? count;

    factory Amenity.fromJson(Map<String, dynamic> json){ 
        return Amenity(
            id: json["id"],
            name: json["name"],
            count: json["count"],
        );
    }

}
