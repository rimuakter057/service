class CompanyInfoModel {
  final String id;
  final String name;
  final String businessType;
  final String country;
  final String tagline;
  final String registrationNumber;
  final String taxNumber;
  final String address;
  final String email;
  final String phone;
  final String website;
  final String facebook;
  final String instagram;
  final String twitter;
  final String appVersionAndroid;
  final String appVersionIos;
  final bool forceUpdate;

  const CompanyInfoModel({
    required this.id,
    required this.name,
    required this.businessType,
    required this.country,
    this.tagline = '',
    this.registrationNumber = '',
    this.taxNumber = '',
    this.address = '',
    this.email = '',
    this.phone = '',
    this.website = '',
    this.facebook = '',
    this.instagram = '',
    this.twitter = '',
    this.appVersionAndroid = '',
    this.appVersionIos = '',
    this.forceUpdate = false,
  });

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) {
    return CompanyInfoModel(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      businessType: (json['business_type'] as String?) ?? '',
      country: (json['country'] as String?) ?? '',
      tagline: (json['tagline'] as String?) ?? '',
      registrationNumber: (json['registration_number'] as String?) ?? '',
      taxNumber: (json['tax_number'] as String?) ?? '',
      address: (json['address'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      website: (json['website'] as String?) ?? '',
      facebook: (json['facebook'] as String?) ?? '',
      instagram: (json['instagram'] as String?) ?? '',
      twitter: (json['twitter'] as String?) ?? '',
      appVersionAndroid: (json['app_version_android'] as String?) ?? '',
      appVersionIos: (json['app_version_ios'] as String?) ?? '',
      forceUpdate: (json['force_update'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'business_type': businessType,
      'country': country,
      'tagline': tagline,
      'registration_number': registrationNumber,
      'tax_number': taxNumber,
      'address': address,
      'email': email,
      'phone': phone,
      'website': website,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'app_version_android': appVersionAndroid,
      'app_version_ios': appVersionIos,
      'force_update': forceUpdate,
    };
  }
}

class CompanyResponseModel {
  final bool success;
  final String message;
  final CompanyInfoModel data;

  const CompanyResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'];
    return CompanyResponseModel(
      success: (json['success'] as bool?) ?? true,
      message: (json['message'] as String?) ?? '',
      data: dataMap is Map<String, dynamic>
          ? CompanyInfoModel.fromJson(dataMap)
          : CompanyInfoModel.fromJson(json),
    );
  }
}
