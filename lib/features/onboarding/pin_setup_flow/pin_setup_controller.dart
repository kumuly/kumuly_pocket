import 'package:kumuly_pocket/features/onboarding/pin_setup_flow/pin_setup_state.dart';
import 'package:kumuly_pocket/services/app_lock_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_setup_controller.g.dart';

@riverpod
class PinSetupController extends _$PinSetupController {
  @override
  PinSetupState build() {
    return const PinSetupState();
  }

  void addNumberToPin(String number) {
    if (state.pin.length < 4) {
      state = state.copyWith(pin: state.pin + number);
    }
  }

  void removeNumberFromPin() {
    if (state.pin.isNotEmpty) {
      state = state.copyWith(pin: state.pin.substring(0, state.pin.length - 1));
    }
  }

  void addNumberToPinConfirmation(String number) {
    if (state.pinConfirmation.length < 4) {
      state = state.copyWith(pinConfirmation: state.pinConfirmation + number);
    }
  }

  void removeNumberFromPinConfirmation() {
    if (state.pinConfirmation.isNotEmpty) {
      state = state.copyWith(
          pinConfirmation: state.pinConfirmation
              .substring(0, state.pinConfirmation.length - 1));
    }
  }

  Future<void> confirmPin() async {
    try {
      // Set the pin.
      await ref
          .read(
            walletServiceImplProvider,
          )
          .setPin(state.pin);
    } catch (e) {
      print(e);
      const error = CouldNotSetPinException();
      state = state.copyWith(error: error);
      throw error;
    }
  }
}

class CouldNotSetPinException implements Exception {
  const CouldNotSetPinException();
}
