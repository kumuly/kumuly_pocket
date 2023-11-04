import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/generation/receive_sats_generation_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReceiveSatsReceptionScreen extends ConsumerWidget {
  const ReceiveSatsReceptionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // To remove the keyboard from inputting the amount
    FocusScope.of(context).unfocus();

    final bip21Uri =
        ref.watch(receiveSatsGenerationControllerProvider).bip21Uri;

    final copy = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.receiveBitcoin,
          style: Theme.of(context).textTheme.display4(
                Palette.neutral[100]!,
                FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Palette.neutral[100]!,
        iconTheme: IconThemeData(color: Palette.neutral[100]!),
      ),
      body: Center(
        child: bip21Uri == null
            ? const Text('Something went wrong.')
            : QrImageView(data: bip21Uri),
      ),
    );
  }
}
