class SendMessageSuccess {
    SendMessageSuccess({
        required this.result,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? result;
    final String? message;
    final int? status;
    final Data? data;

    factory SendMessageSuccess.fromJson(Map<String, dynamic> json){ 
        return SendMessageSuccess(
            result: json["result"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.messages,
    });

    final Messages? messages;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            messages: json["messages"] == null ? null : Messages.fromJson(json["messages"]),
        );
    }

}

class Messages {
    Messages({
        required this.messageId,
        required this.message,
        required this.messageContent,
        required this.attachmentUrl,
        required this.senderId,
        required this.senderName,
        required this.senderImage,
        required this.isRead,
        required this.readAt,
        required this.createdAt,
    });

    final int? messageId;
    final String? message;
    final String? messageContent;
    final dynamic attachmentUrl;
    final int? senderId;
    final String? senderName;
    final String? senderImage;
    final bool? isRead;
    final dynamic readAt;
    final DateTime? createdAt;

    factory Messages.fromJson(Map<String, dynamic> json){ 
        return Messages(
            messageId: json["message_id"],
            message: json["message"],
            messageContent: json["message_content"],
            attachmentUrl: json["attachment_url"],
            senderId: json["sender_id"],
            senderName: json["sender_name"],
            senderImage: json["sender_image"],
            isRead: json["is_read"],
            readAt: json["read_at"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
        );
    }

}
