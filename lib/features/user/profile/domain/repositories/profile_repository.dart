import '../../data/models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile({
    String? fullName,
    String? avatarPath,
    String? gender,
    String? dateOfBirth,
    String? bio,
    String? preferredLanguage,
  });
}
