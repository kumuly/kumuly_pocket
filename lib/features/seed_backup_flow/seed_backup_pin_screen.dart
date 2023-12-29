import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_controller.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/wallet_service.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/pin/pin_controller.dart';
import 'package:kumuly_pocket/widgets/screens/pin_input_screen.dart';

class SeedBackupPinScreen extends ConsumerWidget {
  const SeedBackupPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(
      pageViewControllerProvider(kSeedBackupFlowPageViewId).notifier,
    );

    final pinState = ref.watch(pinControllerProvider);
    final pinNotifier = ref.read(
      pinControllerProvider.notifier,
    );

    final isValidPin =
        ref.watch(checkPinProvider(pinState.pin)).asData?.value ?? false;

    return PinInputScreen(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: pageController.previousPage,
      ),
      pin: pinState.pin,
      isValidPin: isValidPin,
      onNumberSelectHandler: pinNotifier.addNumberToPin,
      onBackspaceHandler: pinNotifier.removeNumberFromPin,
      confirmHandler: () async {
        await ref.read(seedBackupControllerProvider.notifier).loadWords();
        pageController.nextPage();
      },
    );
  }
}
