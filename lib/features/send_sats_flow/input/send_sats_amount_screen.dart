import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/features/send_sats_flow/send_sats_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/screens/amount_input_screen.dart';

class SendSatsAmountScreen extends ConsumerWidget {
  const SendSatsAmountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    final pageController = ref.read(pageViewControllerProvider(
      kSendSatsFlowPageViewId,
    ).notifier);
    final state = ref.watch(sendSatsControllerProvider);

    return AmountInputScreen(
      appBar: AppBar(
        title: Text(
          copy.amountToSend,
          style: textTheme.display4(
            Palette.neutral[100]!,
            FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            pageController.previousPage();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Palette.neutral[100]!,
        iconTheme: IconThemeData(color: Palette.neutral[100]!),
      ),
      textEditingController: state.amountTextController,
      focusNode: state.amountFocusNode,
      label: copy.howMuchToSend,
      readOnly: (state.invoice?.amountSat != null &&
              state.invoice!.amountSat! > 0) ||
          (state.lnurlPay?.minSendableSat != null &&
              state.lnurlPay!.minSendableSat! > 0 &&
              state.lnurlPay?.minSendableSat == state.lnurlPay?.maxSendableSat),
      onChangeHandler:
          ref.read(sendSatsControllerProvider.notifier).amountChangeHandler,
      confirmationHandler: state.amountInputError != null ||
              state.amountSat == null ||
              state.amountSat! <= 0
          ? null
          : () {
              state.amountFocusNode.unfocus();
              pageController.nextPage();
            },
    );
  }
}
