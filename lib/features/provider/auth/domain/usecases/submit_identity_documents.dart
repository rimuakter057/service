import '../repositories/provider_auth_repository.dart';

class SubmitIdentityDocuments {
  const SubmitIdentityDocuments(this._repository);

  final ProviderAuthRepository _repository;

  Future<String> call({
    required String documentType,
    required List<String> filePaths,
  }) {
    return _repository.submitIdentityDocuments(
      documentType: documentType,
      filePaths: filePaths,
    );
  }
}
