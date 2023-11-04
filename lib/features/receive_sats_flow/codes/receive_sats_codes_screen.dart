import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_controller.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReceiveSatsCodesScreen extends ConsumerWidget {
  const ReceiveSatsCodesScreen({
    super.key,
    required this.onNext,
  });

  // Todo: use onNext when the payment is received to go to the completed screen
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;

    final receiveSatsController = receiveSatsControllerProvider(
      ref.watch(breezeSdkLightningNodeServiceProvider),
    );
    final bip21Uri = ref.watch(receiveSatsController).bip21Uri;

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
        child: QrImageView(data: bip21Uri),
      ),
    );
  }
}
