import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/mnemonic_length.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class RecoveryInputScreen extends ConsumerWidget {
  const RecoveryInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);
    final pageViewController = ref.read(
      pageViewControllerProvider(kRecoveryFlowPageViewId).notifier,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          copy.seedImport,
          style: textTheme.display4(
            Palette.neutral[100]!,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kSpacing5,
              ),
              child: Text(
                copy.seedImportHelpText,
                textAlign: TextAlign.center,
                style: textTheme.display3(
                  Palette.neutral[80],
                  FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: kSpacing6),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kSpacing2,
              ),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: state.mnemonicLength.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: kSpacing5,
                  mainAxisSpacing: kSpacing4,
                  childAspectRatio: 144 / 40,
                ),
                itemBuilder: (context, index) => Container(
                  height: 40,
                  width: 144,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kSpacing1),
                    color: Palette.neutral[20],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kSpacing1),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 12,
                          child: Text(
                            '${index + 1}',
                            style: textTheme.display3(
                              Palette.neutral[70]!,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: kSpacing2),
                        Expanded(
                          child: TextFormField(
                            autofocus: index == 0 && state.mnemonic.isEmpty,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            style: textTheme.display3(
                              Palette.neutral[100]!,
                              FontWeight.w400,
                            ),
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => notifier.wordChangeHandler(
                              index,
                              value,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: kSpacing7),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryFilledButton(
                  text: copy.confirm,
                  onPressed: state.mnemonic.isEmpty
                      ? null
                      : pageViewController.nextPage,
                ),
              ],
            ),
            const SizedBox(height: kSpacing3),
          ],
        ),
      ),
    );
  }
}
