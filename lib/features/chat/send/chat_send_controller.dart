import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/features/chat/send/chat_send_state.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/services/chat_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_send_controller.g.dart';

@riverpod
class ChatSendController extends _$ChatSendController {
  @override
  ChatSendState build(String contactId) {
    return const ChatSendState();
  }

  Future<void> amountChangeHandler(String amount) async {
    if (amount.isEmpty) {
      state = ChatSendState(
        amountSat: null,
        amountInputError: null,
        memo: state.memo,
        memoInputError: state.memoInputError,
      );
      return;
    }

    // Todo: Validate amount, check balance, check min and maxsendable etc. and set error if needed

    final unit = ref.watch(bitcoinUnitProvider);
    final amountSat = unit == BitcoinUnit.sat
        ? int.parse(amount)
        : ref.watch(btcToSatProvider(double.parse(amount)));
    state = ChatSendState(
      amountSat: amountSat,
      amountInputError: null,
      memo: state.memo,
      memoInputError: state.memoInputError,
    );
  }

  Future<void> memoChangeHandler(String memo) async {
    // Todo: Validate length etc and set error if needed
    state = state.copyWith(memo: memo, memoInputError: null);
  }

  Future<void> sendHandler() async {
    ref
        .read(sqliteChatServiceProvider)
        .sendToContact(contactId, state.amountSat!);
  }
}
