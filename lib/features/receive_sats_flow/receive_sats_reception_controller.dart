import 'package:breez_sdk/bridge_generated.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/paid_invoice_entity.dart';
import 'package:kumuly_pocket/entities/swap_info_entity.dart';
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
    final invoice = ref.watch(receiveSatsControllerProvider).invoice!;
    final bitcoinAddress =
        ref.watch(receiveSatsControllerProvider).onChainAddress;

    // Start listening for Lightning payment
    ref
        .read(breezeSdkLightningNodeServiceProvider)
        .waitForPayment(
          bolt11: invoice.bolt11,
          paymentHash: invoice.paymentHash,
        )
        .then((value) => onPaymentReceived(value));

    if (bitcoinAddress != null) {
      // Start listening for a swap from an on-chain transaction
      ref
          .read(breezeSdkLightningNodeServiceProvider)
          .inProgressSwapPolling(const Duration(seconds: 5))
          .firstWhere(
            (swap) =>
                ref.watch(receiveSatsControllerProvider).onChainAddress ==
                swap.bitcoinAddress,
          )
          .then((swap) => onSwapInProgress(swap));
    }

    return const ReceiveSatsReceptionState();
  }

  void onPaymentReceived(PaidInvoiceEntity paidInvoice) async {
    state = state.copyWith(
      isPaid: true,
      paymentHash: paidInvoice.paymentHash,
      amountSat: paidInvoice.amountSat,
    );
    ref
        .read(pageViewControllerProvider(kReceiveSatsFlowPageViewId).notifier)
        .nextPage();
  }

  void onSwapInProgress(SwapInfoEntity swap) {
    // Todo: get received amount from swap
    state = state.copyWith(
      isSwapInProgress: true,
      paymentHash: swap.paymentHash,
      amountSat: swap.paidAmountSat,
    );
    ref
        .read(pageViewControllerProvider(kReceiveSatsFlowPageViewId).notifier)
        .nextPage();
  }
}
