import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/backgrounds/background_container.dart';
import 'package:lottie/lottie.dart';

void showTransitionDialog(BuildContext context, String caption) =>
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return TransitionDialog(
          caption: caption,
        );
      },
    );

class TransitionDialog extends StatelessWidget {
  const TransitionDialog({super.key, required this.caption});

  final String caption;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BackgroundContainer(
      color: Palette.lilac[100],
      assetName: 'assets/backgrounds/lilac_background.png',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logos/no_text_logo.png',
            height: 72.0,
            width: 72.0,
          ),
          Column(
            children: [
              Text(
                caption,
                style: textTheme.body2(
                  Colors.white,
                  FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              LottieBuilder.asset(
                'assets/lottie/loading_animation.json',
                width: 96.0,
                height: 24.0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
