import '../../data/models/user_profile_model.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<UserProfileModel> call({
    String? fullName,
    String? avatarPath,
    String? gender,
    String? dateOfBirth,
    String? bio,
    String? preferredLanguage,
  }) {
    return repository.updateProfile(
      fullName: fullName,
      avatarPath: avatarPath,
      gender: gender,
      dateOfBirth: dateOfBirth,
      bio: bio,
      preferredLanguage: preferredLanguage,
    );
  }
}
