import 'enums.dart';

class Dog {
  final String id;
  final String ownerId;
  final String name;
  final String breed;
  final int age;
  final DogGender gender;
  final double? weightKg;
  final String? bio;
  final String? favoriteActivity;
  final DogVerificationStatus verificationStatus;
  final List<String> photoUrls;
  final DogTraits traits;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Dog({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    this.weightKg,
    this.bio,
    this.favoriteActivity,
    this.verificationStatus = DogVerificationStatus.notSubmitted,
    this.photoUrls = const [],
    this.traits = const DogTraits(),
    required this.createdAt,
    required this.updatedAt,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: DogGender.values.firstWhere(
        (e) => e.name == (json['gender'] as String? ?? 'male'),
        orElse: () => DogGender.male,
      ),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      bio: json['bio'] as String?,
      favoriteActivity: json['favorite_activity'] as String?,
      verificationStatus: DogVerificationStatus.fromString(
        json['verification_status'] as String? ?? 'not_submitted',
      ),
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      traits: json['dog_traits'] != null
          ? DogTraits.fromJson(
              (json['dog_traits'] is List)
                  ? (json['dog_traits'] as List).first as Map<String, dynamic>
                  : json['dog_traits'] as Map<String, dynamic>,
            )
          : const DogTraits(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'name': name,
      'breed': breed,
      'age': age,
      'gender': gender.name,
      'weight_kg': weightKg,
      'bio': bio,
      'favorite_activity': favoriteActivity,
      'verification_status': verificationStatus.toDbValue(),
      'photo_urls': photoUrls,
    };
  }

  Dog copyWith({
    String? name,
    String? breed,
    int? age,
    DogGender? gender,
    double? weightKg,
    String? bio,
    String? favoriteActivity,
    DogVerificationStatus? verificationStatus,
    List<String>? photoUrls,
    DogTraits? traits,
  }) {
    return Dog(
      id: id,
      ownerId: ownerId,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      bio: bio ?? this.bio,
      favoriteActivity: favoriteActivity ?? this.favoriteActivity,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      photoUrls: photoUrls ?? this.photoUrls,
      traits: traits ?? this.traits,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  bool get isVerified => verificationStatus == DogVerificationStatus.approved;
  bool get isUnderReview => verificationStatus == DogVerificationStatus.pending;
}

class DogTraits {
  final int energy;
  final int sociability;
  final int adaptability;
  final int trainability;
  final int playfulness;

  const DogTraits({
    this.energy = 50,
    this.sociability = 50,
    this.adaptability = 50,
    this.trainability = 50,
    this.playfulness = 50,
  });

  factory DogTraits.fromJson(Map<String, dynamic> json) {
    return DogTraits(
      energy: json['energy'] as int? ?? 50,
      sociability: json['sociability'] as int? ?? 50,
      adaptability: json['adaptability'] as int? ?? 50,
      trainability: json['trainability'] as int? ?? 50,
      playfulness: json['playfulness'] as int? ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'energy': energy,
      'sociability': sociability,
      'adaptability': adaptability,
      'trainability': trainability,
      'playfulness': playfulness,
    };
  }

  DogTraits copyWith({
    int? energy,
    int? sociability,
    int? adaptability,
    int? trainability,
    int? playfulness,
  }) {
    return DogTraits(
      energy: energy ?? this.energy,
      sociability: sociability ?? this.sociability,
      adaptability: adaptability ?? this.adaptability,
      trainability: trainability ?? this.trainability,
      playfulness: playfulness ?? this.playfulness,
    );
  }
}
