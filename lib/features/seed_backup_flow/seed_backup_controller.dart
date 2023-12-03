import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_state.dart';
import 'package:kumuly_pocket/repositories/mnemonic_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seed_backup_controller.g.dart';

@riverpod
class SeedBackupController extends _$SeedBackupController {
  @override
  SeedBackupState build() {
    return const SeedBackupState();
  }

  Future<void> loadWords(String nodeId) async {
    final mnemonicRepository =
        ref.watch(secureStorageMnemonicRepositoryProvider);
    List<String> words = await mnemonicRepository.getWords(nodeId);

    state = state.copyWith(
      words: words,
    );
  }
}
