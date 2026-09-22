import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({ProfileRemoteDataSource? remoteDataSource})
      : _remoteDataSource =
            remoteDataSource ?? ProfileRemoteDataSourceImpl();

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      return await _remoteDataSource.getProfile();
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load profile. Please try again.');
    }
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
    try {
      return await _remoteDataSource.updateProfile(
        fullName: fullName,
        avatarPath: avatarPath,
        gender: gender,
        dateOfBirth: dateOfBirth,
        bio: bio,
        preferredLanguage: preferredLanguage,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to update profile. Please try again.');
    }
  }
}
