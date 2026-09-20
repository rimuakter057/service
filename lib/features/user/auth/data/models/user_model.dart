import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.publicId,
    super.email,
    super.phone,
    required super.fullName,
    required super.role,
    super.avatar,
    super.gender,
    super.dateOfBirth,
    super.bio,
    required super.isEmailVerified,
    required super.isPhoneVerified,
    required super.isBlocked,
    super.blockedReason,
    required super.ageConfirmed,
    super.preferredLanguage,
    super.providerStatus,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      publicId: json['public_id']?.toString() ?? json['id']?.toString() ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      fullName: json['full_name']?.toString() ?? json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? 'customer',
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      bio: json['bio'] as String?,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      isPhoneVerified: json['is_phone_verified'] as bool? ?? false,
      isBlocked: json['is_blocked'] as bool? ?? false,
      blockedReason: json['blocked_reason'] as String?,
      ageConfirmed: json['age_confirmed'] as bool? ?? false,
      preferredLanguage: json['preferred_language'] as String?,
      providerStatus: json['provider_status'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
