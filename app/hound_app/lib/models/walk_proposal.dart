import 'enums.dart';

class WalkProposal {
  final String id;
  final String proposerUserId;
  final String receiverUserId;
  final String chatThreadId;
  final DateTime proposedDate;
  final WalkTimeOfDay timeOfDay;
  final String? circleName;
  final String? locationNote;
  final String? note;
  final WalkProposalStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WalkProposal({
    required this.id,
    required this.proposerUserId,
    required this.receiverUserId,
    required this.chatThreadId,
    required this.proposedDate,
    required this.timeOfDay,
    this.circleName,
    this.locationNote,
    this.note,
    this.status = WalkProposalStatus.pending,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalkProposal.fromJson(Map<String, dynamic> json) {
    return WalkProposal(
      id: json['id'] as String,
      proposerUserId: json['proposer_user_id'] as String,
      receiverUserId: json['receiver_user_id'] as String,
      chatThreadId: json['chat_thread_id'] as String,
      proposedDate: DateTime.parse(json['proposed_date'] as String),
      timeOfDay: WalkTimeOfDay.values.firstWhere(
        (e) => e.name == (json['time_of_day'] as String? ?? 'morning'),
        orElse: () => WalkTimeOfDay.morning,
      ),
      circleName: json['circle_name'] as String?,
      locationNote: json['location_note'] as String?,
      note: json['note'] as String?,
      status: WalkProposalStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'pending'),
        orElse: () => WalkProposalStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proposer_user_id': proposerUserId,
      'receiver_user_id': receiverUserId,
      'chat_thread_id': chatThreadId,
      'proposed_date': proposedDate.toIso8601String(),
      'time_of_day': timeOfDay.name,
      'circle_name': circleName,
      'location_note': locationNote,
      'note': note,
      'status': status.name,
    };
  }
}
