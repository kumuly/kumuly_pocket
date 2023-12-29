import 'package:kumuly_pocket/features/seed_import_flow/seed_import_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seed_import_controller.g.dart';

@riverpod
class SeedImportController extends _$SeedImportController {
  @override
  dynamic build() {
    return const SeedImportState();
  }
}
