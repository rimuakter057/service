import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/provider_day_availability_model.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_provider_day_availability.dart';

class ProviderAvailabilityNotifier extends ChangeNotifier {
  ProviderAvailabilityNotifier({HomeRepository? repository})
      : _getDayAvailability =
            GetProviderDayAvailability(repository ?? HomeRepositoryImpl());

  final GetProviderDayAvailability _getDayAvailability;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProviderDayAvailabilityModel? _availabilityModel;
  ProviderDayAvailabilityModel? get availabilityModel => _availabilityModel;

  String? _selectedDate;
  String? get selectedDate => _selectedDate;

  final Set<int> _selectedSlots = {0};
  Set<int> get selectedSlots => _selectedSlots;

  void toggleSlot(int index) {
    if (_availabilityModel == null || index < 0 || index >= _availabilityModel!.slots.length) {
      return;
    }
    final slot = _availabilityModel!.slots[index];
    if (!slot.isAvailable) return;

    if (_selectedSlots.contains(index)) {
      _selectedSlots.remove(index);
    } else {
      _selectedSlots.add(index);
    }
    notifyListeners();
  }

  Future<void> fetchAvailability({
    required String providerId,
    String? date,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    if (date != null && date.trim().isNotEmpty) {
      _selectedDate = date.trim();
    }
    notifyListeners();

    try {
      final result = await _getDayAvailability(
        providerId,
        date: _selectedDate,
      );
      _availabilityModel = result;
      _errorMessage = null;

      // Ensure valid selected slots within available ones
      _selectedSlots.removeWhere((idx) =>
          idx >= result.slots.length || !result.slots[idx].isAvailable);
      if (_selectedSlots.isEmpty) {
        final firstAvailableIndex =
            result.slots.indexWhere((s) => s.isAvailable);
        if (firstAvailableIndex != -1) {
          _selectedSlots.add(firstAvailableIndex);
        }
      }
    } on Failure catch (failure) {
      _errorMessage = failure.message;
      // If server error or offline, fallback safely so UI doesn't crash
      _availabilityModel ??=
          ProviderDayAvailabilityModel.fallback(date: _selectedDate);
    } catch (e) {
      _errorMessage = 'Failed to load availability.';
      _availabilityModel ??=
          ProviderDayAvailabilityModel.fallback(date: _selectedDate);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
