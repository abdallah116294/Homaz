class LoginUserSuccess {
    LoginUserSuccess({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory LoginUserSuccess.fromJson(Map<String, dynamic> json){ 
        return LoginUserSuccess(
            result: json["result"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.user,
    });

    final User? user;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            user: json["user"] == null ? null : User.fromJson(json["user"]),
        );
    }

}

class User {
    User({
        required this.id,
        required this.fullname,
        required this.isActive,
        required this.email,
        required this.image,
        required this.phone,
        required this.token,
    });

    final int? id;
    final String? fullname;
    final bool? isActive;
    final dynamic email;
    final String? image;
    final String? phone;
    final String? token;

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            id: json["id"],
            fullname: json["fullname"],
            isActive: json["is_active"],
            email: json["email"],
            image: json["image"],
            phone: json["phone"],
            token: json["token"],
        );
    }

}
