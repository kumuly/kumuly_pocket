import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/pin/numeric_keyboard.dart';
import 'package:kumuly_pocket/widgets/pin/pin_code_display.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinInputScreen extends ConsumerWidget {
  const PinInputScreen({
    this.leading,
    this.title,
    this.subtitle,
    required this.pin,
    this.isValidPin = false,
    this.errorMessage,
    required this.onNumberSelectHandler,
    required this.onBackspaceHandler,
    this.confirmButtonText,
    this.confirmHandler,
    super.key,
  });

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final String pin;
  final bool isValidPin;
  final String? errorMessage;
  final dynamic Function(String) onNumberSelectHandler;
  final dynamic Function() onBackspaceHandler;
  final String? confirmButtonText;
  final void Function()? confirmHandler;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: leading,
        title: Text(
          title ?? copy.pin,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing4),
              child: Text(
                subtitle ?? copy.enterYourPIN,
                textAlign: TextAlign.center,
                style: textTheme.display3(
                  Palette.neutral[60],
                  FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: kSpacing13),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing12),
              child: PinCodeDisplay(pinCode: pin),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: kSpacing2, left: kSpacing3, right: kSpacing3),
              height: kSpacing16,
              child: pin.length == 4 && !isValidPin
                  ? Text(
                      errorMessage ?? copy.incorrectPIN,
                      style: textTheme.body3(
                        Colors.red.withOpacity(0.7),
                        FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    )
                  : Container(), // Empty container when no error
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing8),
              child: NumericKeyboard(
                onNumberSelected: onNumberSelectHandler,
                onBackspace: pin.isNotEmpty ? onBackspaceHandler : null,
                onConfirmation: pin.length != 4 || !isValidPin
                    ? null
                    : confirmHandler ?? router.pop,
              ),
            ),
            const SizedBox(height: kSpacing8),
          ],
        ),
      ),
    );
  }
}
