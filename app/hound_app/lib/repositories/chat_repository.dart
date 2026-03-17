import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_message.dart';
import '../services/supabase_service.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(supabaseClientProvider));
});

final chatThreadsProvider = FutureProvider<List<ChatThread>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(chatRepositoryProvider).getUserThreads(user.id);
});

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  Future<List<ChatThread>> getUserThreads(String userId) async {
    final response = await _client
        .from('chat_threads')
        .select()
        .or('participant_1_id.eq.$userId,participant_2_id.eq.$userId')
        .eq('is_active', true)
        .order('last_message_at', ascending: false);
    return (response as List).map((t) => ChatThread.fromJson(t)).toList();
  }

  Future<ChatThread?> getThread(String threadId) async {
    final response = await _client
        .from('chat_threads')
        .select()
        .eq('id', threadId)
        .maybeSingle();
    if (response == null) return null;
    return ChatThread.fromJson(response);
  }

  Future<List<ChatMessage>> getMessages(String threadId, {int limit = 50}) async {
    final response = await _client
        .from('chat_messages')
        .select()
        .eq('thread_id', threadId)
        .order('created_at', ascending: true)
        .limit(limit);
    return (response as List).map((m) => ChatMessage.fromJson(m)).toList();
  }

  Future<ChatMessage> sendMessage({
    required String threadId,
    required String senderId,
    required String content,
    String? imageUrl,
  }) async {
    final response = await _client
        .from('chat_messages')
        .insert({
          'thread_id': threadId,
          'sender_id': senderId,
          'content': content,
          'image_url': imageUrl,
        })
        .select()
        .single();
    return ChatMessage.fromJson(response);
  }

  Future<void> markAsRead(String threadId, String userId) async {
    await _client
        .from('chat_messages')
        .update({'is_read': true})
        .eq('thread_id', threadId)
        .neq('sender_id', userId)
        .eq('is_read', false);
  }

  /// Subscribe to new messages in a thread via Supabase Realtime
  RealtimeChannel subscribeToMessages(
    String threadId,
    void Function(ChatMessage message) onMessage,
  ) {
    return _client
        .channel('chat:$threadId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'thread_id',
            value: threadId,
          ),
          callback: (payload) {
            final message = ChatMessage.fromJson(payload.newRecord);
            onMessage(message);
          },
        )
        .subscribe();
  }

  void unsubscribeFromMessages(String threadId) {
    _client.removeChannel(_client.channel('chat:$threadId'));
  }
}
