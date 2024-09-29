class ChatsModel {
    ChatsModel({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory ChatsModel.fromJson(Map<String, dynamic> json){ 
        return ChatsModel(
            result: json["result"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.chats,
    });

    final Chats? chats;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            chats: json["chats"] == null ? null : Chats.fromJson(json["chats"]),
        );
    }

}

class Chats {
    Chats({
        required this.data,
        required this.links,
        required this.meta,
    });

    final List<Datum> data;
    final Links? links;
    final Meta? meta;

    factory Chats.fromJson(Map<String, dynamic> json){ 
        return Chats(
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
            links: json["links"] == null ? null : Links.fromJson(json["links"]),
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        );
    }

}

class Datum {
    Datum({
        required this.chatId,
        required this.userImage,
        required this.userName,
        required this.aparmentId,
        required this.aparmentName,
        required this.aparmentImage,
        required this.unreadCount,
        required this.lastMessage,
        required this.lastMessageTime,
    });

    final int? chatId;
    final String? userImage;
    final String? userName;
    final int? aparmentId;
    final String? aparmentName;
    final String? aparmentImage;
    final int? unreadCount;
    final String? lastMessage;
    final String? lastMessageTime;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            chatId: json["chat_id"],
            userImage: json["user_image"],
            userName: json["user_name"],
            aparmentId: json["aparment_id"],
            aparmentName: json["aparment_name"],
            aparmentImage: json["aparment_image"],
            unreadCount: json["unread_count"],
            lastMessage: json["last_message"],
            lastMessageTime: json["last_message_time"],
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
