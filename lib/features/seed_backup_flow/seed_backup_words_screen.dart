import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SeedBackupWordsScreen extends ConsumerWidget {
  const SeedBackupWordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final pageController = ref
        .watch(pageViewControllerProvider(kSeedBackupFlowPageViewId))
        .pageController;
    final state = ref.watch(seedBackupControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => pageController.jumpToPage(0),
        ),
        title: Text(
          copy.yourSeedWords,
          style: textTheme.display4(
            Palette.neutral[100],
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: IconThemeData(color: Palette.neutral[100]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kSpacing4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                copy.writeDownAndNumberSeedWords,
                style: textTheme.body4(
                  Palette.neutral[80],
                  FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: kSpacing4,
              ),
              GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: state.words.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: kSpacing3,
                  mainAxisSpacing: kSpacing4,
                  childAspectRatio: 4,
                ),
                itemBuilder: (context, index) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${index + 1}.',
                          style: textTheme.display4(
                            Palette.neutral[40],
                            FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: kSpacing3),
                        Text(
                          state.words[index],
                          style: textTheme.display4(
                            Palette.neutral[100],
                            FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    Divider(color: Palette.neutral[20]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
