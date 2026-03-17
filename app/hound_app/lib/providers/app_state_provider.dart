import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/enums.dart';
import '../models/profile.dart';
import '../models/dog.dart';
import '../repositories/profile_repository.dart';
import '../repositories/dog_repository.dart';
import '../services/supabase_service.dart';

/// Determines the app navigation state based on user's profile and dog status
enum AppNavigationState {
  unauthenticated,
  waitlist,
  approved,
  addDog,
  dogUnderReview,
  ready,
}

final appNavigationStateProvider = FutureProvider<AppNavigationState>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return AppNavigationState.unauthenticated;

  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return AppNavigationState.unauthenticated;

  switch (profile.applicationStatus) {
    case ApplicationStatus.pending:
    case ApplicationStatus.inReview:
      return AppNavigationState.waitlist;
    case ApplicationStatus.rejected:
      return AppNavigationState.waitlist;
    case ApplicationStatus.approved:
      break;
  }

  // User is approved, check dog status
  final dog = await ref.watch(currentUserDogProvider.future);
  if (dog == null) return AppNavigationState.addDog;

  if (dog.verificationStatus == DogVerificationStatus.pending) {
    return AppNavigationState.dogUnderReview;
  }

  return AppNavigationState.ready;
});

/// Whether intro actions should be enabled
final canSendIntrosProvider = FutureProvider<bool>((ref) async {
  final dog = await ref.watch(currentUserDogProvider.future);
  if (dog == null) return false;
  return dog.verificationStatus == DogVerificationStatus.approved;
});

/// Whether discovery should be accessible
final canAccessDiscoveryProvider = FutureProvider<bool>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return false;
  if (profile.applicationStatus != ApplicationStatus.approved) return false;

  final dog = await ref.watch(currentUserDogProvider.future);
  return dog != null;
});
