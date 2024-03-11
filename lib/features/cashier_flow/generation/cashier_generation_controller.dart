import 'package:kumuly_pocket/features/cashier_flow/generation/cashier_generation_state.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/services/lightning_node/impl/breez_sdk_lightning_node_service.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cashier_generation_controller.g.dart';

@riverpod
class CashierGenerationController extends _$CashierGenerationController {
  @override
  CashierGenerationState build() {
    ref.watch(fiatRatesProvider(ref.read(localCurrencyProvider)));
    return const CashierGenerationState(amountSat: 0);
  }

  Future<void> amountChangeHandler(String? amount) async {
    if (amount == null || amount.isEmpty) {
      state = state.copyWith(
        localCurrencyAmount: null,
        amountSat: 0,
      );
    } else {
      final localCurrencyAmount = double.parse(amount);
      final amountSat =
          await ref.read(localToSatProvider(localCurrencyAmount).future);

      state = state.copyWith(
        localCurrencyAmount: localCurrencyAmount,
        amountSat: amountSat,
      );
    }
  }

  Future<void> createInvoice() async {
    final invoice =
        await ref.read(breezeSdkLightningNodeServiceProvider).createInvoice(
              state.amountSat!,
              state.description,
              null,
            );

    print(invoice);

    state = state.copyWith(invoice: Invoice.fromInvoiceEntity(invoice));
  }
}
