class RegisterUserSuccess {
  RegisterUserSuccess({
    required this.result,
    required this.message,
    required this.status,
    required this.data,
  });

  final String? result;
  final String? message;
  final int? status;
  final Data? data;

  factory RegisterUserSuccess.fromJson(Map<String, dynamic> json) {
    return RegisterUserSuccess(
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

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }
}

class User {
  User({
    required this.id,
    required this.otp,
    required this.phone,
    required this.email,
    required this.image,
  });

  final int? id;
  final int? otp;
  final String? phone;
  final String? email;
  final String? image;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      otp: json["otp"],
      phone: json["phone"],
      email: json['email'],
      image: json["image"],
    );
  }
}
