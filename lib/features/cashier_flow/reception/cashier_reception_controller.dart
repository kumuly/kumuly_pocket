import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/cashier_flow/generation/cashier_generation_controller.dart';
import 'package:kumuly_pocket/services/lightning_node/impl/breez_sdk_lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cashier_reception_controller.g.dart';

@riverpod
class CashierReceptionController extends _$CashierReceptionController {
  @override
  void build() {
    final invoice = ref.watch(cashierGenerationControllerProvider).invoice;
    if (invoice != null) {
      final lightningListener = ref
          .read(breezeSdkLightningNodeServiceProvider)
          .paidInvoiceStream
          .listen((event) {
        if (invoice.bolt11 == event.bolt11 ||
            event.paymentHash == invoice.paymentHash) {
          onReceived();
        }
      });

      ref.onDispose(() {
        lightningListener.cancel();
      });
    }
  }

  void onReceived() async {
    ref
        .read(pageViewControllerProvider(kCashierFlowPageViewId).notifier)
        .nextPage();
  }
}
