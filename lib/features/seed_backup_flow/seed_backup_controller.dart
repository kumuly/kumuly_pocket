import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_state.dart';
import 'package:kumuly_pocket/services/mnemonic_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seed_backup_controller.g.dart';

@riverpod
class SeedBackupController extends _$SeedBackupController {
  @override
  SeedBackupState build() {
    return const SeedBackupState();
  }

  Future<void> loadWords(String mnemonicLabel, String pin) async {
    final mnemonicService =
        ref.watch(masterKeyEncryptedMnemonicServiceProvider);
    final mnemonic = await mnemonicService.getMnemonic(mnemonicLabel, pin);
    List<String> words = mnemonic.split(' ');

    state = state.copyWith(
      words: words,
    );
  }
}
