import '../../data/models/user_profile_model.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfileModel> call() {
    return repository.getProfile();
  }
}
