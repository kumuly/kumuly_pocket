import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/generation/receive_sats_generation_controller.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/reception/receive_sats_reception_state.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_sats_reception_controller.g.dart';

@riverpod
class ReceiveSatsReceptionController extends _$ReceiveSatsReceptionController {
  @override
  ReceiveSatsReceptionState build() {
    final invoice = ref.watch(receiveSatsGenerationControllerProvider).invoice;
    final swapAvailable =
        ref.watch(receiveSatsGenerationControllerProvider).isSwapAvailable;
    final bitcoinAddress =
        ref.watch(receiveSatsGenerationControllerProvider).onChainAddress;

    if (invoice != null) {
      // Start listening for Lightning payment
      ref
          .read(breezeSdkLightningNodeServiceProvider)
          .streamInvoicePayment(
            bolt11: invoice.bolt11,
            paymentHash: invoice.paymentHash,
          )
          .firstWhere(
            (paid) => paid,
          )
          .then((value) => onPaymentReceived());

      if (swapAvailable && bitcoinAddress != null) {
        // Start listening for a swap from an on-chain transaction
        ref
            .read(breezeSdkLightningNodeServiceProvider)
            .inProgressSwapPolling(const Duration(seconds: 5))
            .firstWhere(
              (bitcoinAddress) =>
                  ref
                      .watch(receiveSatsGenerationControllerProvider)
                      .onChainAddress ==
                  bitcoinAddress,
            )
            .then((value) => onSwapInProgress());
      }
    }

    return const ReceiveSatsReceptionState();
  }

  void onPaymentReceived() async {
    state = state.copyWith(
      isPaid: true,
    );
    ref
        .read(pageViewControllerProvider(kReceiveSatsFlowPageViewId).notifier)
        .nextPage();
  }

  void onSwapInProgress() {
    state = state.copyWith(
      isSwapInProgress: true,
    );
    ref
        .read(pageViewControllerProvider(kReceiveSatsFlowPageViewId).notifier)
        .nextPage();
  }
}
