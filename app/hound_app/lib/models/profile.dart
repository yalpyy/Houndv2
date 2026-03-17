import 'enums.dart';

class Profile {
  final String id;
  final String fullName;
  final String? email;
  final String? avatarUrl;
  final String? city;
  final String? circle;
  final String? bio;
  final String? referralCode;
  final String? referredBy;
  final ApplicationStatus applicationStatus;
  final MembershipTier membershipTier;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.fullName,
    this.email,
    this.avatarUrl,
    this.city,
    this.circle,
    this.bio,
    this.referralCode,
    this.referredBy,
    this.applicationStatus = ApplicationStatus.pending,
    this.membershipTier = MembershipTier.standard,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      city: json['city'] as String?,
      circle: json['circle'] as String?,
      bio: json['bio'] as String?,
      referralCode: json['referral_code'] as String?,
      referredBy: json['referred_by'] as String?,
      applicationStatus: ApplicationStatus.fromString(
        json['application_status'] as String? ?? 'pending',
      ),
      membershipTier: MembershipTier.values.firstWhere(
        (e) => e.name == (json['membership_tier'] as String? ?? 'standard'),
        orElse: () => MembershipTier.standard,
      ),
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'city': city,
      'circle': circle,
      'bio': bio,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'application_status': applicationStatus.toDbValue(),
      'membership_tier': membershipTier.name,
      'is_verified': isVerified,
    };
  }

  Profile copyWith({
    String? fullName,
    String? email,
    String? avatarUrl,
    String? city,
    String? circle,
    String? bio,
    String? referralCode,
    ApplicationStatus? applicationStatus,
    MembershipTier? membershipTier,
    bool? isVerified,
  }) {
    return Profile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      circle: circle ?? this.circle,
      bio: bio ?? this.bio,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy,
      applicationStatus: applicationStatus ?? this.applicationStatus,
      membershipTier: membershipTier ?? this.membershipTier,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
