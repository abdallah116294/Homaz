class FavoriteModel {
    FavoriteModel({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory FavoriteModel.fromJson(Map<String, dynamic> json){ 
        return FavoriteModel(
            result: json["result"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.apartment,
    });

    final Apartment? apartment;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            apartment: json["Apartment"] == null ? null : Apartment.fromJson(json["Apartment"]),
        );
    }

}

class Apartment {
    Apartment({
        required this.data,
        required this.links,
        required this.meta,
    });

    final List<Datum> data;
    final Links? links;
    final Meta? meta;

    factory Apartment.fromJson(Map<String, dynamic> json){ 
        return Apartment(
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
            links: json["links"] == null ? null : Links.fromJson(json["links"]),
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        );
    }

}

class Datum {
    Datum({
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

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
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

class Links {
    Links({
        required this.first,
        required this.last,
        required this.prev,
        required this.next,
    });

    final String? first;
    final String? last;
    final dynamic prev;
    final dynamic next;

    factory Links.fromJson(Map<String, dynamic> json){ 
        return Links(
            first: json["first"],
            last: json["last"],
            prev: json["prev"],
            next: json["next"],
        );
    }

}

class Meta {
    Meta({
        required this.currentPage,
        required this.from,
        required this.lastPage,
        required this.links,
        required this.path,
        required this.perPage,
        required this.to,
        required this.total,
    });

    final int? currentPage;
    final int? from;
    final int? lastPage;
    final List<Link> links;
    final String? path;
    final int? perPage;
    final int? to;
    final int? total;

    factory Meta.fromJson(Map<String, dynamic> json){ 
        return Meta(
            currentPage: json["current_page"],
            from: json["from"],
            lastPage: json["last_page"],
            links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
            path: json["path"],
            perPage: json["per_page"],
            to: json["to"],
            total: json["total"],
        );
    }

}

class Link {
    Link({
        required this.url,
        required this.label,
        required this.active,
    });

    final String? url;
    final String? label;
    final bool? active;

    factory Link.fromJson(Map<String, dynamic> json){ 
        return Link(
            url: json["url"],
            label: json["label"],
            active: json["active"],
        );
    }

}
