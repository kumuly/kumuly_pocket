import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/cashier_flow/generation/cashier_generation_controller.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cashier_reception_controller.g.dart';

@riverpod
class CashierReceptionController extends _$CashierReceptionController {
  @override
  void build() {
    ref
        .read(breezeSdkLightningNodeServiceProvider)
        .streamInvoicePayment(
          bolt11: ref.watch(cashierGenerationControllerProvider).invoice,
        )
        .firstWhere((paid) => paid)
        .then((value) => onReceived());
  }

  void onReceived() async {
    ref
        .read(pageViewControllerProvider(kCashierFlowPageViewId).notifier)
        .nextPage();
  }
}
