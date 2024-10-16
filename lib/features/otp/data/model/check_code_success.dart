class CheckCodeSuccess {
    CheckCodeSuccess({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory CheckCodeSuccess.fromJson(Map<String, dynamic> json){ 
        return CheckCodeSuccess(
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
        required this.phone,
        required this.otp,
    });

    final String? phone;
    final int? otp;

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            phone: json["phone"],
            otp: json["otp"],
        );
    }

}
