import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_controller.dart';
import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_pin_screen.dart';
import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_start_screen.dart';
import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_words_screen.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class SeedBackupFlow extends ConsumerWidget {
  const SeedBackupFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider(
      kSeedBackupFlowPageViewId,
    ));
    ref.watch(seedBackupControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        SeedBackupStartScreen(),
        SeedBackupPinScreen(),
        SeedBackupWordsScreen(),
      ],
    );
  }
}
