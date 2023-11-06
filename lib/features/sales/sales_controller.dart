import 'package:kumuly_pocket/features/sales/sales_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_controller.g.dart';

@riverpod
class SalesController extends _$SalesController {
  @override
  SalesState build() {
    return const SalesState(balanceSat: null, payments: null);
  }
}
