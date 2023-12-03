import 'package:kumuly_pocket/widgets/pin/pin_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_controller.g.dart';

@riverpod
class PinController extends _$PinController {
  @override
  PinState build() {
    return const PinState();
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
}
