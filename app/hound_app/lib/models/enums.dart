enum ApplicationStatus {
  pending,
  inReview,
  approved,
  rejected;

  String get displayName {
    switch (this) {
      case ApplicationStatus.pending:
        return 'BEKLEMEDE';
      case ApplicationStatus.inReview:
        return 'İNCELEMEDE';
      case ApplicationStatus.approved:
        return 'ONAYLANDI';
      case ApplicationStatus.rejected:
        return 'REDDEDİLDİ';
    }
  }

  static ApplicationStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return ApplicationStatus.pending;
      case 'in_review':
        return ApplicationStatus.inReview;
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      default:
        return ApplicationStatus.pending;
    }
  }

  String toDbValue() {
    switch (this) {
      case ApplicationStatus.pending:
        return 'pending';
      case ApplicationStatus.inReview:
        return 'in_review';
      case ApplicationStatus.approved:
        return 'approved';
      case ApplicationStatus.rejected:
        return 'rejected';
    }
  }
}

enum DogVerificationStatus {
  notSubmitted,
  pending,
  approved,
  rejected;

  String get displayName {
    switch (this) {
      case DogVerificationStatus.notSubmitted:
        return 'GÖNDERİLMEDİ';
      case DogVerificationStatus.pending:
        return 'İNCELEMEDE';
      case DogVerificationStatus.approved:
        return 'ONAYLANDI';
      case DogVerificationStatus.rejected:
        return 'REDDEDİLDİ';
    }
  }

  static DogVerificationStatus fromString(String value) {
    switch (value) {
      case 'not_submitted':
        return DogVerificationStatus.notSubmitted;
      case 'pending':
        return DogVerificationStatus.pending;
      case 'approved':
        return DogVerificationStatus.approved;
      case 'rejected':
        return DogVerificationStatus.rejected;
      default:
        return DogVerificationStatus.notSubmitted;
    }
  }

  String toDbValue() {
    switch (this) {
      case DogVerificationStatus.notSubmitted:
        return 'not_submitted';
      case DogVerificationStatus.pending:
        return 'pending';
      case DogVerificationStatus.approved:
        return 'approved';
      case DogVerificationStatus.rejected:
        return 'rejected';
    }
  }
}

enum DogGender {
  male,
  female;

  String get displayName {
    switch (this) {
      case DogGender.male:
        return 'Erkek';
      case DogGender.female:
        return 'Dişi';
    }
  }
}

enum IntroRequestStatus {
  pending,
  accepted,
  rejected,
  expired;

  String get displayName {
    switch (this) {
      case IntroRequestStatus.pending:
        return 'BEKLEMEDE';
      case IntroRequestStatus.accepted:
        return 'ONAYLANDI';
      case IntroRequestStatus.rejected:
        return 'REDDEDİLDİ';
      case IntroRequestStatus.expired:
        return 'SÜRESİ DOLDU';
    }
  }

  static IntroRequestStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return IntroRequestStatus.pending;
      case 'accepted':
        return IntroRequestStatus.accepted;
      case 'rejected':
        return IntroRequestStatus.rejected;
      case 'expired':
        return IntroRequestStatus.expired;
      default:
        return IntroRequestStatus.pending;
    }
  }
}

enum WalkTimeOfDay {
  morning,
  noon,
  evening,
  sunset;

  String get displayName {
    switch (this) {
      case WalkTimeOfDay.morning:
        return 'Sabah';
      case WalkTimeOfDay.noon:
        return 'Öğle';
      case WalkTimeOfDay.evening:
        return 'Akşam';
      case WalkTimeOfDay.sunset:
        return 'Gün Batımı';
    }
  }

  String get icon {
    switch (this) {
      case WalkTimeOfDay.morning:
        return 'wb_sunny';
      case WalkTimeOfDay.noon:
        return 'light_mode';
      case WalkTimeOfDay.evening:
        return 'wb_twilight';
      case WalkTimeOfDay.sunset:
        return 'dark_mode';
    }
  }
}

enum WalkProposalStatus {
  pending,
  accepted,
  rejected,
  cancelled,
  completed;

  String get displayName {
    switch (this) {
      case WalkProposalStatus.pending:
        return 'BEKLEMEDE';
      case WalkProposalStatus.accepted:
        return 'KABUL EDİLDİ';
      case WalkProposalStatus.rejected:
        return 'REDDEDİLDİ';
      case WalkProposalStatus.cancelled:
        return 'İPTAL EDİLDİ';
      case WalkProposalStatus.completed:
        return 'TAMAMLANDI';
    }
  }
}

enum MembershipTier {
  standard,
  premium,
  elite;

  String get displayName {
    switch (this) {
      case MembershipTier.standard:
        return 'STANDART';
      case MembershipTier.premium:
        return 'PREMİUM';
      case MembershipTier.elite:
        return 'ELİT';
    }
  }
}
