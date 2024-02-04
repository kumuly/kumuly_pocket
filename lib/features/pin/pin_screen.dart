import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/services/pin_derived_encrypted_key_management_service.dart';
import 'package:kumuly_pocket/widgets/pin/pin_controller.dart';
import 'package:kumuly_pocket/widgets/screens/pin_input_screen.dart';

class PinScreen extends ConsumerWidget {
  const PinScreen({required this.confirmHandler, super.key});

  final VoidCallback confirmHandler;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);

    final pinState = ref.watch(pinControllerProvider);
    final pinNotifier = ref.read(
      pinControllerProvider.notifier,
    );
    final isValidPin =
        ref.watch(checkPinProvider(pinState.pin)).asData?.value ?? false;

    return PinInputScreen(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: router.pop,
      ),
      pin: pinState.pin,
      isValidPin: isValidPin,
      onNumberSelectHandler: pinNotifier.addNumberToPin,
      onBackspaceHandler: pinNotifier.removeNumberFromPin,
      confirmHandler: confirmHandler,
    );
  }
}
