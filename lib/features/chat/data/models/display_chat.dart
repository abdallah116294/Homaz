class DisplayChat {
  DisplayChat({
    required this.result,
    required this.message,
    required this.status,
    required this.data,
  });

  final String? result;
  final String? message;
  final int? status;
  final Data? data;

  factory DisplayChat.fromJson(Map<String, dynamic> json) {
    return DisplayChat(
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

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      chat: json["chat"] == null ? null : Chat.fromJson(json["chat"]),
    );
  }
}

class Chat {
  Chat({
    required this.chatId,
    required this.messages,
  });

  final int? chatId;
  final List<Message> messages;

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json["chat_id"],
      messages: json["messages"] == null
          ? []
          : List<Message>.from(
              json["messages"]!.map((x) => Message.fromJson(x))),
    );
  }
}

class Message {
  Message({
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
  final String? attachmentUrl;
  final int? senderId;
  final String? senderName;
  final String? senderImage;
  final bool? isRead;
  final dynamic readAt;
  final DateTime? createdAt;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
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
