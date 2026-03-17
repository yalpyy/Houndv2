import 'enums.dart';
import 'dog.dart';
import 'profile.dart';

class IntroRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String fromDogId;
  final String toDogId;
  final String? message;
  final IntroRequestStatus status;
  final String? chatThreadId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  final Dog? fromDog;
  final Dog? toDog;
  final Profile? fromUser;
  final Profile? toUser;

  const IntroRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.fromDogId,
    required this.toDogId,
    this.message,
    this.status = IntroRequestStatus.pending,
    this.chatThreadId,
    required this.createdAt,
    required this.updatedAt,
    this.fromDog,
    this.toDog,
    this.fromUser,
    this.toUser,
  });

  factory IntroRequest.fromJson(Map<String, dynamic> json) {
    return IntroRequest(
      id: json['id'] as String,
      fromUserId: json['from_user_id'] as String,
      toUserId: json['to_user_id'] as String,
      fromDogId: json['from_dog_id'] as String,
      toDogId: json['to_dog_id'] as String,
      message: json['message'] as String?,
      status: IntroRequestStatus.fromString(
        json['status'] as String? ?? 'pending',
      ),
      chatThreadId: json['chat_thread_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      fromDog: json['from_dog'] != null
          ? Dog.fromJson(json['from_dog'] as Map<String, dynamic>)
          : null,
      toDog: json['to_dog'] != null
          ? Dog.fromJson(json['to_dog'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'from_dog_id': fromDogId,
      'to_dog_id': toDogId,
      'message': message,
      'status': status.name,
    };
  }
}
