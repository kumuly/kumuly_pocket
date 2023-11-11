import 'package:kumuly_pocket/features/cashier_flow/generation/cashier_generation_state.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cashier_generation_controller.g.dart';

@riverpod
class CashierGenerationController extends _$CashierGenerationController {
  @override
  CashierGenerationState build() {
    return const CashierGenerationState();
  }

  void amountChangeHandler(String? amount) {
    if (amount == null || amount.isEmpty) {
      state = state.copyWith(
        localCurrencyAmount: null,
        amountSat: null,
      );
    } else {
      final localCurrencyAmount = double.parse(amount);
      final amountSat = ref.read(localToSatProvider(localCurrencyAmount));
      state = state.copyWith(
        localCurrencyAmount: localCurrencyAmount,
        amountSat: amountSat,
      );
      print('local currency amount: $localCurrencyAmount');
      print('amount sat: $amountSat');
    }
  }

  Future<void> createInvoice() async {
    final invoice =
        await ref.read(breezeSdkLightningNodeServiceProvider).createInvoice(
              state.amountSat!,
              state.description,
            );

    print(invoice);

    state = state.copyWith(invoice: invoice);
  }
}
