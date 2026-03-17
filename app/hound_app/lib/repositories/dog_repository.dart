import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dog.dart';
import '../models/enums.dart';
import '../services/supabase_service.dart';

final dogRepositoryProvider = Provider<DogRepository>((ref) {
  return DogRepository(ref.watch(supabaseClientProvider));
});

final currentUserDogProvider = FutureProvider<Dog?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.watch(dogRepositoryProvider).getUserDog(user.id);
});

final discoveryDogsProvider = FutureProvider<List<Dog>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(dogRepositoryProvider).getDiscoveryDogs(user.id);
});

class DogRepository {
  final SupabaseClient _client;

  DogRepository(this._client);

  Future<Dog?> getUserDog(String userId) async {
    final response = await _client
        .from('dogs')
        .select('*, dog_traits(*)')
        .eq('owner_id', userId)
        .maybeSingle();
    if (response == null) return null;
    return Dog.fromJson(response);
  }

  Future<Dog?> getDogById(String dogId) async {
    final response = await _client
        .from('dogs')
        .select('*, dog_traits(*)')
        .eq('id', dogId)
        .maybeSingle();
    if (response == null) return null;
    return Dog.fromJson(response);
  }

  Future<List<Dog>> getDiscoveryDogs(String currentUserId) async {
    final response = await _client
        .from('dogs')
        .select('*, dog_traits(*)')
        .neq('owner_id', currentUserId)
        .eq('verification_status', 'approved')
        .order('created_at', ascending: false);
    return (response as List).map((d) => Dog.fromJson(d)).toList();
  }

  Future<Dog> createDog({
    required String ownerId,
    required String name,
    required String breed,
    required int age,
    required DogGender gender,
    double? weightKg,
    String? bio,
    String? favoriteActivity,
    required DogTraits traits,
  }) async {
    final dogResponse = await _client
        .from('dogs')
        .insert({
          'owner_id': ownerId,
          'name': name,
          'breed': breed,
          'age': age,
          'gender': gender.name,
          'weight_kg': weightKg,
          'bio': bio,
          'favorite_activity': favoriteActivity,
        })
        .select()
        .single();

    final dogId = dogResponse['id'] as String;

    // Create traits
    await _client.from('dog_traits').insert({
      'dog_id': dogId,
      ...traits.toJson(),
    });

    return Dog.fromJson(dogResponse);
  }

  Future<void> updateDog(Dog dog) async {
    await _client
        .from('dogs')
        .update(dog.toJson())
        .eq('id', dog.id);

    // Update traits
    await _client
        .from('dog_traits')
        .upsert({
          'dog_id': dog.id,
          ...dog.traits.toJson(),
        })
        .eq('dog_id', dog.id);
  }

  Future<void> submitForReview(String dogId) async {
    await _client
        .from('dogs')
        .update({'verification_status': 'pending'})
        .eq('id', dogId);
  }

  Future<String> uploadDogPhoto(String userId, String dogId, File file) async {
    final ext = file.path.split('.').last;
    final path = '$userId/$dogId/${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _client.storage.from('dog-photos').upload(path, file);
    return _client.storage.from('dog-photos').getPublicUrl(path);
  }

  Future<String> uploadVerificationDoc(
    String userId,
    String dogId,
    File file,
    String docType,
  ) async {
    final ext = file.path.split('.').last;
    final path = '$userId/$dogId/$docType.$ext';
    await _client.storage.from('verification-docs').upload(path, file);

    final url = _client.storage.from('verification-docs').getPublicUrl(path);

    await _client.from('dog_verification_docs').insert({
      'dog_id': dogId,
      'doc_type': docType,
      'file_url': url,
      'file_name': file.path.split('/').last,
    });

    return url;
  }
}
