import '../../data/models/provider_booking_detail_model.dart';
import '../repositories/provider_booking_repository.dart';

class GetProviderBookingDetailUseCase {
  final ProviderBookingRepository repository;

  GetProviderBookingDetailUseCase(this.repository);

  Future<ProviderBookingDetailModel> call(String bookingId) {
    return repository.getProviderBookingDetail(bookingId);
  }
}
