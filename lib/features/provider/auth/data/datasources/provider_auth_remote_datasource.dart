import 'package:dio/dio.dart';
import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';

abstract class ProviderAuthRemoteDataSource {
  Future<Map<String, dynamic>> register({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
    required bool ageConfirmed,
  });

  Future<Map<String, dynamic>> verifyOtp({
    required String identifier,
    required String code,
  });

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  });

  Future<Map<String, dynamic>?> logout();

  Future<Map<String, dynamic>> requestPasswordResetOtp({
    required String identifier,
  });

  Future<Map<String, dynamic>> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  });

  Future<Map<String, dynamic>> resetPassword({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Map<String, dynamic>> submitIdentityDocuments({
    required String documentType,
    required List<String> filePaths,
  });
}

class ProviderAuthRemoteDataSourceImpl implements ProviderAuthRemoteDataSource {
  ProviderAuthRemoteDataSourceImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> register({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
    required bool ageConfirmed,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.providerRegister,
      data: {
        'identifier': identifier,
        'full_name': fullName,
        'password': password,
        'confirm_password': confirmPassword,
        'role': 'provider',
        'accept_terms': acceptTerms,
        'age_confirmed': ageConfirmed,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String identifier,
    required String code,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.providerOtpVerify,
      data: {'identifier': identifier, 'code': code},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.providerLogin,
      data: {
        'identifier': identifier,
        'password': password,
        'remember_me': rememberMe,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>?> logout() async {
    try {
      final response = await _apiClient.post(ApiUrl.providerLogout);
      return response.data as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> requestPasswordResetOtp({
    required String identifier,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.providerOtpRequest,
      data: {'identifier': identifier},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.providerOtpVerify,
      data: {'identifier': identifier, 'code': code},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.providerPasswordReset,
      data: {
        'identifier': identifier,
        'verification_token': verificationToken,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> submitIdentityDocuments({
    required String documentType,
    required List<String> filePaths,
  }) async {
    final multipartFiles = <MultipartFile>[];
    for (final path in filePaths) {
      final fileName = path.split(RegExp(r'[/\\]')).last;
      multipartFiles.add(
        await MultipartFile.fromFile(path, filename: fileName),
      );
    }

    final formData = FormData.fromMap({
      'document_type': documentType,
      'files': multipartFiles,
    });

    final response = await _apiClient.post(
      ApiUrl.providerIdentity,
      data: formData,
    );
    return response.data as Map<String, dynamic>;
  }
}
