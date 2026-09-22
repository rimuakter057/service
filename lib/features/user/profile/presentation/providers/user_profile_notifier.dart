import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';

class UserProfileNotifier extends ChangeNotifier {
  UserProfileNotifier({ProfileRepository? repository})
      : _getProfile = GetUserProfileUseCase(repository ?? ProfileRepositoryImpl()),
        _updateProfile =
            UpdateUserProfileUseCase(repository ?? ProfileRepositoryImpl());

  final GetUserProfileUseCase _getProfile;
  final UpdateUserProfileUseCase _updateProfile;

  UserProfileModel? _profile;
  UserProfileModel? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _updateErrorMessage;
  String? get updateErrorMessage => _updateErrorMessage;

  /// Fetch user profile from GET /api/v1/customer/auth/me/
  Future<void> fetchProfile({bool forceRefresh = false}) async {
    if (_profile != null && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _getProfile();
      _errorMessage = null;
    } on Failure catch (failure) {
      _errorMessage = failure.message;
    } catch (e) {
      _errorMessage = 'Failed to load profile. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile via PATCH /api/v1/customer/auth/me/
  Future<bool> updateProfile({
    String? fullName,
    String? avatarPath,
    String? gender,
    String? dateOfBirth,
    String? bio,
    String? preferredLanguage,
  }) async {
    _isUpdating = true;
    _updateErrorMessage = null;
    notifyListeners();

    try {
      final updated = await _updateProfile(
        fullName: fullName,
        avatarPath: avatarPath,
        gender: gender,
        dateOfBirth: dateOfBirth,
        bio: bio,
        preferredLanguage: preferredLanguage,
      );
      _profile = updated;
      _updateErrorMessage = null;
      _isUpdating = false;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _updateErrorMessage = failure.message;
      _isUpdating = false;
      notifyListeners();
      return false;
    } catch (e) {
      _updateErrorMessage = 'Failed to update profile. Please try again.';
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }
}
