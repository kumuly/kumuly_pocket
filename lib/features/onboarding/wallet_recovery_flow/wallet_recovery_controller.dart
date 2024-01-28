import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/mnemonic_entity.dart';
import 'package:kumuly_pocket/features/onboarding/wallet_recovery_flow/wallet_recovery_state.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/services/app_lock_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_recovery_controller.g.dart';

@riverpod
class WalletRecoveryController extends _$WalletRecoveryController {
  @override
  WalletRecoveryState build() {
    return WalletRecoveryState(
      words: List<String>.filled(
        (24 * kSeedEntropyLength / kMaxSeedEntropyLength).round(),
        '',
      ),
    );
  }

  void wordChangeHandler(int index, String word) {
    // TODO: validate word and only allow valid words
    // TODO: set suggested words
    state = state.copyWith(
      words: [
        ...state.words.sublist(0, index),
        word,
        ...state.words.sublist(index + 1),
      ],
    );
  }

  Future<void> importSeed() async {
    try {
      await ref.watch(walletServiceImplProvider).saveWallet(
            MnemonicEntity(words: state.words, language: state.language),
          );
    } catch (e) {
      print(e);
      throw BadSeedException(e.toString());
    }
    try {
      await ref
          .watch(breezeSdkLightningNodeServiceProvider)
          .connect(ref.read(bitcoinNetworkProvider));
    } catch (e) {
      print(e);
      throw NodeConnectionException(e.toString());
    }
  }
}

class BadSeedException implements Exception {
  BadSeedException(this.message);

  final String message;
}

class NodeConnectionException implements Exception {
  NodeConnectionException(this.message);

  final String message;
}
