class AppConstants {
  AppConstants._();

  // Supabase - replace with actual values in .env
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  // App
  static const String appName = 'HOUND';
  static const String appTagline = 'Özel seçki bir köpek topluluğu';
  static const String appEstablished = 'EST. 2024';

  // Limits
  static const int maxDogPhotos = 6;
  static const int maxTraitValue = 100;
  static const int minTraitValue = 0;
  static const int applicationSteps = 5;

  // Storage buckets
  static const String dogPhotosBucket = 'dog-photos';
  static const String verificationDocsBucket = 'verification-docs';
  static const String avatarsBucket = 'avatars';

  // Realtime channels
  static const String chatChannel = 'chat_messages';
}
