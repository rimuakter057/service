/// The logged-in customer, as returned by the backend after OTP
/// verification. Field names mirror the API response (see `data.user` in
/// the verify-otp response) so [UserModel.fromJson] stays a direct mapping.
class User {
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

  const User({
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
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isBlocked,
    this.blockedReason,
    required this.ageConfirmed,
    this.preferredLanguage,
    this.providerStatus,
    this.createdAt,
  });
}
