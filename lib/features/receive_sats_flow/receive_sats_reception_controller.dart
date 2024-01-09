import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_controller.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_reception_state.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_sats_reception_controller.g.dart';

@riverpod
class ReceiveSatsReceptionController extends _$ReceiveSatsReceptionController {
  @override
  ReceiveSatsReceptionState build() {
    final invoice = ref.watch(receiveSatsControllerProvider).invoice;
    final bitcoinAddress =
        ref.watch(receiveSatsControllerProvider).onChainAddress;

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

      if (bitcoinAddress != null) {
        // Start listening for a swap from an on-chain transaction
        ref
            .read(breezeSdkLightningNodeServiceProvider)
            .inProgressSwapPolling(const Duration(seconds: 5))
            .firstWhere(
              (bitcoinAddress) =>
                  ref.watch(receiveSatsControllerProvider).onChainAddress ==
                  bitcoinAddress,
            )
            .then((value) => onSwapInProgress());
      }
    }

    return const ReceiveSatsReceptionState();
  }

  void onPaymentReceived() async {
    // Todo: get received amount from invoice
    state = state.copyWith(
      isPaid: true,
    );
    ref
        .read(pageViewControllerProvider(kReceiveSatsFlowPageViewId).notifier)
        .nextPage();
  }

  void onSwapInProgress() {
    // Todo: get received amount from swap
    state = state.copyWith(
      isSwapInProgress: true,
    );
    ref
        .read(pageViewControllerProvider(kReceiveSatsFlowPageViewId).notifier)
        .nextPage();
  }
}
