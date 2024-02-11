import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:confetti/confetti.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_reception_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/amounts/bitcoin_amount_display.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';

class ReceiveSatsCompletedScreen extends ConsumerStatefulWidget {
  const ReceiveSatsCompletedScreen({
    super.key,
  });

  @override
  ReceiveSatsCompletedScreenState createState() =>
      ReceiveSatsCompletedScreenState();
}

class ReceiveSatsCompletedScreenState
    extends ConsumerState<ReceiveSatsCompletedScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 30));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);
    final state = ref.watch(receiveSatsReceptionControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(kSpacing1),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Palette.neutral[100]!,
              ),
              onPressed: () => router.pop(),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                state.isPaid
                    ? 'assets/images/payment_received.png'
                    : 'assets/images/payment_pending.png',
                width: 160.0,
                height: 160.0,
              ),
              Column(
                children: [
                  Text(
                    state.isPaid ? copy.paymentReceived : copy.paymentInProcess,
                    style: textTheme.display5(
                      Palette.success[50],
                      FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  BitcoinAmountDisplay(
                    prefix: '+ ',
                    amountSat: state.amountSat,
                    amountStyle: textTheme.display7(
                      state.isPaid ? Palette.success[50] : Palette.neutral[60],
                      FontWeight.w700,
                    ),
                  ),
                ],
              ),
              PrimaryTextButton(
                text: copy.paymentDetails,
                trailingIcon: Icon(
                  Icons.arrow_forward_ios,
                  color: Palette.neutral[100],
                  size: 16.0,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
                confettiController: _confettiController,
                shouldLoop: true,
                blastDirection: pi / 2,
                maxBlastForce: 5, // set a lower max blast force
                minBlastForce: 2, // set a lower min blast force
                numberOfParticles: 20,
                gravity: 0.05,
                minimumSize: const Size(10, 5),
                maximumSize: const Size(20, 10),
                particleDrag: 0.05,
                canvas: const Size(double.infinity, double.infinity),
                colors: [
                  Palette.orange[75]!,
                ]),
          ),
        ],
      ),
    );
  }
}
