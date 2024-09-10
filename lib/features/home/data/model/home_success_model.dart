class HomeSuccessModel {
    HomeSuccessModel({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory HomeSuccessModel.fromJson(Map<String, dynamic> json){ 
        return HomeSuccessModel(
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
        required this.apartments,
        required this.apartmentTypes,
    });

    final List<ApartmentType> categories;
    final List<Apartment> apartments;
    final List<ApartmentType> apartmentTypes;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            categories: json["categories"] == null ? [] : List<ApartmentType>.from(json["categories"]!.map((x) => ApartmentType.fromJson(x))),
            apartments: json["apartments"] == null ? [] : List<Apartment>.from(json["apartments"]!.map((x) => Apartment.fromJson(x))),
            apartmentTypes: json["apartment_types"] == null ? [] : List<ApartmentType>.from(json["apartment_types"]!.map((x) => ApartmentType.fromJson(x))),
        );
    }

}

class ApartmentType {
    ApartmentType({
        required this.id,
        required this.name,
    });

    final int? id;
    final String? name;

    factory ApartmentType.fromJson(Map<String, dynamic> json){ 
        return ApartmentType(
            id: json["id"],
            name: json["name"],
        );
    }

}

class Apartment {
    Apartment({
        required this.id,
        required this.name,
        required this.mainImage,
    });

    final int? id;
    final String? name;
    final String? mainImage;

    factory Apartment.fromJson(Map<String, dynamic> json){ 
        return Apartment(
            id: json["id"],
            name: json["name"],
            mainImage: json["main_image"],
        );
    }

}
