import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class OnboardingInviteCodeScreen extends ConsumerWidget {
  const OnboardingInviteCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final pageController = ref.read(
      pageViewControllerProvider(
        kOnboardingFlowPageViewId,
      ).notifier,
    );

    final notifier = ref.read(
      onboardingControllerProvider(kInviteCodeLength).notifier,
    );
    final state = ref.watch(onboardingControllerProvider(kInviteCodeLength));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.inviteCode,
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: kSpacing3),
                Text(
                  copy.inviteCodeDescription,
                  textAlign: TextAlign.center,
                  style: textTheme.display3(
                    Palette.neutral[100]!.withOpacity(0.3),
                    FontWeight.w400,
                  ),
                ),
                const SizedBox(height: kSpacing12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(kInviteCodeLength, (index) {
                    if (index == 4) {
                      return Text(
                        '-',
                        style: textTheme.display6(
                          Palette.neutral[100],
                          FontWeight.normal,
                        ),
                      );
                    }

                    return SizedBox(
                      width: 40,
                      child: TextFormField(
                        autofocus: index == 0 && state.inviteCode.isEmpty,
                        controller: state.inviteCodeControllers[index],
                        focusNode: state.inviteCodeFocusNodes[index],
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 1,
                        style: textTheme.display6(
                          Palette.neutral[100],
                          FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'X',
                          hintStyle: textTheme.display6(
                            Palette.neutral[50],
                            FontWeight.normal,
                          ),
                          counterText: '',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) =>
                            notifier.inviteCodeChangeHandler(index, value),
                        textInputAction: TextInputAction.next,
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
          const SizedBox(height: kSpacing8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              PrimaryFilledButton(
                text: copy.confirmInviteCode,
                onPressed: state.inviteCode.isEmpty
                    ? null
                    : () {
                        for (var element in state.inviteCodeFocusNodes) {
                          element.unfocus();
                        }
                        pageController.nextPage();
                      },
              ),
            ],
          ),
          const SizedBox(height: kSpacing3),
        ],
      ),
    );
  }
}
