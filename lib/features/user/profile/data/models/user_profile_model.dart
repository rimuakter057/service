class UserProfileModel {
  final String id;
  final String publicId;
  final String? email;
  final String? phone;
  final String fullName;
  final String role;
  final String? avatar;
  final String? gender;
  final String? dateOfBirth;
  final String? bio;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isBlocked;
  final String? blockedReason;
  final bool ageConfirmed;
  final String? preferredLanguage;
  final String? providerStatus;
  final String? createdAt;

  const UserProfileModel({
    required this.id,
    required this.publicId,
    this.email,
    this.phone,
    required this.fullName,
    required this.role,
    this.avatar,
    this.gender,
    this.dateOfBirth,
    this.bio,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.isBlocked = false,
    this.blockedReason,
    this.ageConfirmed = false,
    this.preferredLanguage,
    this.providerStatus,
    this.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'public_id': publicId,
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'role': role,
      'avatar': avatar,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'bio': bio,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'is_blocked': isBlocked,
      'blocked_reason': blockedReason,
      'age_confirmed': ageConfirmed,
      'preferred_language': preferredLanguage,
      'provider_status': providerStatus,
      'created_at': createdAt,
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? publicId,
    String? email,
    String? phone,
    String? fullName,
    String? role,
    String? avatar,
    String? gender,
    String? dateOfBirth,
    String? bio,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isBlocked,
    String? blockedReason,
    bool? ageConfirmed,
    String? preferredLanguage,
    String? providerStatus,
    String? createdAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      publicId: publicId ?? this.publicId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bio: bio ?? this.bio,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isBlocked: isBlocked ?? this.isBlocked,
      blockedReason: blockedReason ?? this.blockedReason,
      ageConfirmed: ageConfirmed ?? this.ageConfirmed,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      providerStatus: providerStatus ?? this.providerStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserProfileResponseModel {
  final bool success;
  final String message;
  final UserProfileModel data;

  const UserProfileResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return UserProfileResponseModel(
      success: (json['success'] as bool?) ?? true,
      message: (json['message'] as String?) ?? '',
      data: rawData is Map<String, dynamic>
          ? UserProfileModel.fromJson(rawData)
          : const UserProfileModel(
              id: '',
              publicId: '',
              fullName: '',
              role: 'customer',
            ),
    );
  }
}
