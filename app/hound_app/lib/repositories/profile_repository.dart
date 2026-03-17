import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import '../services/supabase_service.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(supabaseClientProvider));
});

final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.watch(profileRepositoryProvider).getProfile(user.id);
});

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  Future<Profile?> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (response == null) return null;
    return Profile.fromJson(response);
  }

  Future<void> updateProfile(Profile profile) async {
    await _client
        .from('profiles')
        .update(profile.toJson())
        .eq('id', profile.id);
  }

  Future<void> submitApplication({
    required String userId,
    required String fullName,
    String? city,
    String? circle,
    String? referralCode,
    String? dogName,
    String? dogBreed,
    int? dogAge,
    String? lifestyleNotes,
    String? howHeard,
  }) async {
    await _client.from('applications_waitlist').insert({
      'user_id': userId,
      'full_name': fullName,
      'city': city,
      'circle': circle,
      'referral_code_used': referralCode,
      'dog_name': dogName,
      'dog_breed': dogBreed,
      'dog_age': dogAge,
      'lifestyle_notes': lifestyleNotes,
      'how_heard': howHeard,
    });

    // Update profile status to in_review
    await _client
        .from('profiles')
        .update({
          'application_status': 'in_review',
          'full_name': fullName,
          'city': city,
          'circle': circle,
        })
        .eq('id', userId);
  }

  Future<Map<String, dynamic>?> getApplication(String userId) async {
    return await _client
        .from('applications_waitlist')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
  }
}
