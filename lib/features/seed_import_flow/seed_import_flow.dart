import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/seed_import_flow/pages/seed_import_completed_screen.dart';
import 'package:kumuly_pocket/features/seed_import_flow/pages/seed_import_input_screen.dart';
import 'package:kumuly_pocket/features/seed_import_flow/seed_import_controller.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class SeedImportFlow extends ConsumerWidget {
  const SeedImportFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider(
      kSeedImportFlowPageViewId,
    ));
    ref.watch(seedImportControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        SeedImportInputScreen(),
        SeedImportCompletedScreen(),
      ],
    );
  }
}
