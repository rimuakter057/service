import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/core/errors/failures.dart';
import 'package:nchito/features/user/profile/data/models/user_profile_model.dart';
import 'package:nchito/features/user/profile/domain/repositories/profile_repository.dart';
import 'package:nchito/features/user/profile/presentation/providers/user_profile_notifier.dart';

class MockProfileRepository implements ProfileRepository {
  bool shouldThrow = false;
  String? updatedName;

  UserProfileModel mockProfile = const UserProfileModel(
    id: "6aae24ddea04f420b202918e",
    publicId: "a5547b6e-9a28-4a19-acf8-c14ee04ec701",
    email: "customer333@yopmail.com",
    phone: "+260971234567",
    fullName: "Customer Test",
    role: "customer",
    avatar: "http://example.com/avatar.jpg",
    gender: "male",
    dateOfBirth: "1995-05-15",
    bio: "Test bio",
    isEmailVerified: true,
    isPhoneVerified: true,
    isBlocked: false,
    blockedReason: null,
    ageConfirmed: true,
    preferredLanguage: "en",
    providerStatus: null,
    createdAt: "2026-09-22T04:10:16.791Z",
  );

  @override
  Future<UserProfileModel> getProfile() async {
    if (shouldThrow) {
      throw const NetworkFailure('Network error');
    }
    return mockProfile;
  }

  @override
  Future<UserProfileModel> updateProfile({
    String? fullName,
    String? avatarPath,
    String? gender,
    String? dateOfBirth,
    String? bio,
    String? preferredLanguage,
  }) async {
    if (shouldThrow) {
      throw const ServerFailure('Failed to update profile');
    }
    updatedName = fullName;
    mockProfile = mockProfile.copyWith(
      fullName: fullName ?? mockProfile.fullName,
    );
    return mockProfile;
  }
}

void main() {
  group('UserProfileModel', () {
    test('fromJson deserializes backend response correctly', () {
      final json = {
        "id": "123",
        "public_id": "pub_123",
        "email": "test@example.com",
        "phone": "0971234567",
        "full_name": "Jane Doe",
        "role": "customer",
        "avatar": "http://img.png",
        "gender": "female",
        "date_of_birth": "1990-01-01",
        "bio": "Hello world",
        "is_email_verified": true,
        "is_phone_verified": true,
        "is_blocked": false,
        "blocked_reason": null,
        "age_confirmed": true,
        "preferred_language": "en",
        "provider_status": null,
        "created_at": "2026-09-22T00:00:00.000Z",
      };

      final profile = UserProfileModel.fromJson(json);
      expect(profile.id, "123");
      expect(profile.fullName, "Jane Doe");
      expect(profile.email, "test@example.com");
      expect(profile.isEmailVerified, isTrue);
    });
  });

  group('UserProfileNotifier', () {
    late MockProfileRepository repository;
    late UserProfileNotifier notifier;

    setUp(() {
      repository = MockProfileRepository();
      notifier = UserProfileNotifier(repository: repository);
    });

    test('fetchProfile successfully sets profile and clears loading', () async {
      expect(notifier.isLoading, isFalse);
      expect(notifier.profile, isNull);

      final future = notifier.fetchProfile();
      expect(notifier.isLoading, isTrue);
      await future;

      expect(notifier.isLoading, isFalse);
      expect(notifier.profile, isNotNull);
      expect(notifier.profile?.fullName, "Customer Test");
      expect(notifier.errorMessage, isNull);
    });

    test('fetchProfile sets errorMessage on failure', () async {
      repository.shouldThrow = true;
      await notifier.fetchProfile();

      expect(notifier.isLoading, isFalse);
      expect(notifier.profile, isNull);
      expect(notifier.errorMessage, "Network error");
    });

    test('updateProfile successfully updates profile', () async {
      await notifier.fetchProfile();
      expect(notifier.profile?.fullName, "Customer Test");

      final success = await notifier.updateProfile(fullName: "Updated Name");
      expect(success, isTrue);
      expect(notifier.profile?.fullName, "Updated Name");
      expect(notifier.isUpdating, isFalse);
      expect(notifier.updateErrorMessage, isNull);
    });

    test('updateProfile handles failure correctly', () async {
      await notifier.fetchProfile();
      repository.shouldThrow = true;

      final success = await notifier.updateProfile(fullName: "Will Fail");
      expect(success, isFalse);
      expect(notifier.isUpdating, isFalse);
      expect(notifier.updateErrorMessage, "Failed to update profile");
    });
  });
}
