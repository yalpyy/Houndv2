import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/intro_request.dart';
import '../services/supabase_service.dart';

final introRepositoryProvider = Provider<IntroRepository>((ref) {
  return IntroRepository(ref.watch(supabaseClientProvider));
});

final receivedIntrosProvider = FutureProvider<List<IntroRequest>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(introRepositoryProvider).getReceivedIntros(user.id);
});

final sentIntrosProvider = FutureProvider<List<IntroRequest>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(introRepositoryProvider).getSentIntros(user.id);
});

class IntroRepository {
  final SupabaseClient _client;

  IntroRepository(this._client);

  Future<List<IntroRequest>> getReceivedIntros(String userId) async {
    final response = await _client
        .from('intro_requests')
        .select('*, from_dog:dogs!from_dog_id(*, dog_traits(*))')
        .eq('to_user_id', userId)
        .order('created_at', ascending: false);
    return (response as List).map((r) => IntroRequest.fromJson(r)).toList();
  }

  Future<List<IntroRequest>> getSentIntros(String userId) async {
    final response = await _client
        .from('intro_requests')
        .select('*, to_dog:dogs!to_dog_id(*, dog_traits(*))')
        .eq('from_user_id', userId)
        .order('created_at', ascending: false);
    return (response as List).map((r) => IntroRequest.fromJson(r)).toList();
  }

  Future<void> sendIntroRequest({
    required String fromUserId,
    required String toUserId,
    required String fromDogId,
    required String toDogId,
    String? message,
  }) async {
    await _client.from('intro_requests').insert({
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'from_dog_id': fromDogId,
      'to_dog_id': toDogId,
      'message': message,
    });
  }

  Future<void> acceptIntro(String introId) async {
    await _client
        .from('intro_requests')
        .update({'status': 'accepted'})
        .eq('id', introId);
  }

  Future<void> rejectIntro(String introId) async {
    await _client
        .from('intro_requests')
        .update({'status': 'rejected'})
        .eq('id', introId);
  }
}
