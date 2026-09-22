import 'package:dio/dio.dart';
import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
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

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<UserProfileModel> getProfile() async {
    final response = await _apiClient.get(ApiUrl.customerMe);
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return UserProfileResponseModel.fromJson(responseData).data;
    }
    throw FormatException('Unexpected response format: $responseData');
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
    dynamic payload;

    if (avatarPath != null && avatarPath.trim().isNotEmpty) {
      final formMap = <String, dynamic>{};
      if (fullName != null && fullName.trim().isNotEmpty) {
        formMap['full_name'] = fullName.trim();
      }
      if (gender != null && gender.trim().isNotEmpty) {
        formMap['gender'] = gender.trim();
      }
      if (dateOfBirth != null && dateOfBirth.trim().isNotEmpty) {
        formMap['date_of_birth'] = dateOfBirth.trim();
      }
      if (bio != null) {
        formMap['bio'] = bio;
      }
      if (preferredLanguage != null && preferredLanguage.trim().isNotEmpty) {
        formMap['preferred_language'] = preferredLanguage.trim();
      }
      formMap['avatar'] = await MultipartFile.fromFile(
        avatarPath.trim(),
        filename: avatarPath.split(r'\').last.split('/').last,
      );
      payload = FormData.fromMap(formMap);
    } else {
      final jsonMap = <String, dynamic>{};
      if (fullName != null) {
        jsonMap['full_name'] = fullName.trim();
      }
      if (gender != null) {
        jsonMap['gender'] = gender.trim();
      }
      if (dateOfBirth != null) {
        jsonMap['date_of_birth'] = dateOfBirth.trim();
      }
      if (bio != null) {
        jsonMap['bio'] = bio;
      }
      if (preferredLanguage != null) {
        jsonMap['preferred_language'] = preferredLanguage.trim();
      }
      payload = jsonMap;
    }

    final response = await _apiClient.patch(
      ApiUrl.customerMe,
      data: payload,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return UserProfileResponseModel.fromJson(responseData).data;
    }
    throw FormatException('Unexpected response format: $responseData');
  }
}
