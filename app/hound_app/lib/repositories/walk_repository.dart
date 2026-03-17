import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/walk_proposal.dart';
import '../models/enums.dart';
import '../services/supabase_service.dart';

final walkRepositoryProvider = Provider<WalkRepository>((ref) {
  return WalkRepository(ref.watch(supabaseClientProvider));
});

class WalkRepository {
  final SupabaseClient _client;

  WalkRepository(this._client);

  Future<List<WalkProposal>> getProposalsForThread(String threadId) async {
    final response = await _client
        .from('walk_proposals')
        .select()
        .eq('chat_thread_id', threadId)
        .order('created_at', ascending: false);
    return (response as List).map((w) => WalkProposal.fromJson(w)).toList();
  }

  Future<void> createProposal({
    required String proposerUserId,
    required String receiverUserId,
    required String chatThreadId,
    required DateTime proposedDate,
    required WalkTimeOfDay timeOfDay,
    String? circleName,
    String? locationNote,
    String? note,
  }) async {
    await _client.from('walk_proposals').insert({
      'proposer_user_id': proposerUserId,
      'receiver_user_id': receiverUserId,
      'chat_thread_id': chatThreadId,
      'proposed_date': proposedDate.toIso8601String().split('T').first,
      'time_of_day': timeOfDay.name,
      'circle_name': circleName,
      'location_note': locationNote,
      'note': note,
    });
  }

  Future<void> acceptProposal(String proposalId) async {
    await _client
        .from('walk_proposals')
        .update({'status': 'accepted'})
        .eq('id', proposalId);
  }

  Future<void> rejectProposal(String proposalId) async {
    await _client
        .from('walk_proposals')
        .update({'status': 'rejected'})
        .eq('id', proposalId);
  }
}
