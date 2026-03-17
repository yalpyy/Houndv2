class ChatThread {
  final String id;
  final String introRequestId;
  final String participant1Id;
  final String participant2Id;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;

  // Joined
  final String? otherUserName;
  final String? otherUserAvatar;
  final String? otherDogName;

  const ChatThread({
    required this.id,
    required this.introRequestId,
    required this.participant1Id,
    required this.participant2Id,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    required this.createdAt,
    this.otherUserName,
    this.otherUserAvatar,
    this.otherDogName,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(
      id: json['id'] as String,
      introRequestId: json['intro_request_id'] as String,
      participant1Id: json['participant_1_id'] as String,
      participant2Id: json['participant_2_id'] as String,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      unreadCount: json['unread_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class ChatMessage {
  final String id;
  final String threadId;
  final String senderId;
  final String content;
  final String? imageUrl;
  final bool isRead;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.content,
    this.imageUrl,
    this.isRead = false,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thread_id': threadId,
      'sender_id': senderId,
      'content': content,
      'image_url': imageUrl,
    };
  }
}
