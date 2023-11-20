import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendSatsExpiredInvoiceScreen extends ConsumerWidget {
  const SendSatsExpiredInvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Palette.neutral[100]!,
        iconTheme: IconThemeData(color: Palette.neutral[100]!),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: router.pop,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/time_out.png',
              width: 216.0,
              height: 232.0,
            ),
            const SizedBox(height: kSpacing7),
            Text(
              copy.invoiceExpiredAlready,
              style: textTheme.display8(
                Palette.neutral[90],
                FontWeight.w400,
              ),
            ),
            const SizedBox(height: kSpacing2),
            Text(
              copy.invoiceExpiredInstructions,
              style: textTheme.body4(
                Palette.neutral[70],
                FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
