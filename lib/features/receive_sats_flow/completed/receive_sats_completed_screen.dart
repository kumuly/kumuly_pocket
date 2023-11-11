import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/generation/receive_sats_generation_controller.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/reception/receive_sats_reception_controller.dart';

class ReceiveSatsCompletedScreen extends ConsumerWidget {
  const ReceiveSatsCompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generationProvider =
        ref.watch(receiveSatsGenerationControllerProvider);
    final receptionProvider = ref.watch(receiveSatsReceptionControllerProvider);

    final amountSat = generationProvider.amountSat;
    final isPaid = receptionProvider.isPaid;
    final isSwapInProgress = receptionProvider.isSwapInProgress;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPaid
                ? Text(
                    'You received $amountSat sats',
                  )
                : Container(),
            isSwapInProgress
                ? const Text(
                    'On-chain swap in progress',
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
