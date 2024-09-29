class PusherEventModel {
    PusherEventModel({
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

    factory PusherEventModel.fromJson(Map<String, dynamic> json){ 
        return PusherEventModel(
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
