import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/models/user.dart';
import 'package:nekotomo_app/services/api_service.dart';

/// Pet state for the provider
class PetProviderState {
  final Pet? pet;
  final bool isLoading;
  final String? error;
  final String? message;

  PetProviderState({
    this.pet,
    this.isLoading = false,
    this.error,
    this.message,
  });

  PetProviderState copyWith({
    Pet? pet,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return PetProviderState(
      pet: pet ?? this.pet,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      message: message,
    );
  }
}

class PetNotifier extends StateNotifier<PetProviderState> {
  final ApiService _api = ApiService();

  PetNotifier() : super(PetProviderState());

  Future<void> loadPet() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _api.getPet();
      final pet = Pet.fromJson(response.data);
      state = PetProviderState(pet: pet);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load pet');
    }
  }

  Future<bool> feedPet() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _api.feedPet();
      final data = response.data;
      final pet = Pet.fromJson(data['pet']);
      final hungerGain = data['hungerGain'] ?? 0;
      final happinessGain = data['happinessGain'] ?? 0;
      state = PetProviderState(
        pet: pet,
        message: '+$hungerGain Hunger, +$happinessGain Happiness',
      );
      return true;
    } catch (e) {
      final msg = _extractError(e);
      state = state.copyWith(isLoading: false, error: msg);
      return false;
    }
  }

  Future<bool> playWithPet() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _api.playWithPet();
      final data = response.data;
      final pet = Pet.fromJson(data['pet']);
      final happinessGain = data['happinessGain'] ?? 0;
      state = PetProviderState(
        pet: pet,
        message: '+$happinessGain Happiness',
      );
      return true;
    } catch (e) {
      final msg = _extractError(e);
      state = state.copyWith(isLoading: false, error: msg);
      return false;
    }
  }

  void clearMessage() {
    state = state.copyWith(message: null, error: null);
  }

  String _extractError(dynamic e) {
    try {
      final dioError = e as dynamic;
      return dioError.response?.data?['error'] ?? 'Something went wrong';
    } catch (_) {
      return 'Connection problem. Please try again.';
    }
  }
}

final petProvider = StateNotifierProvider<PetNotifier, PetProviderState>((ref) {
  return PetNotifier();
});
