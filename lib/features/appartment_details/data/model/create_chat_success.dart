class CreateChatSuccessful {
    CreateChatSuccessful({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory CreateChatSuccessful.fromJson(Map<String, dynamic> json){ 
        return CreateChatSuccessful(
            result: json["result"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.chat,
    });

    final Chat? chat;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            chat: json["chat"] == null ? null : Chat.fromJson(json["chat"]),
        );
    }

}

class Chat {
    Chat({
        required this.id,
        required this.apartmentId,
        required this.userId,
    });

    final int? id;
    final String? apartmentId;
    final int? userId;

    factory Chat.fromJson(Map<String, dynamic> json){ 
        return Chat(
            id: json["id"],
            apartmentId: json["apartment_id"],
            userId: json["user_id"],
        );
    }

}
