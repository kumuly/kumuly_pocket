import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/send_sats_flow/completed/send_sats_completed_screen.dart';
import 'package:kumuly_pocket/features/send_sats_flow/input/send_sats_amount_screen.dart';
import 'package:kumuly_pocket/features/send_sats_flow/input/send_sats_destination_screen.dart';
import 'package:kumuly_pocket/features/send_sats_flow/overview/send_sats_overview_screen.dart';
import 'package:kumuly_pocket/features/send_sats_flow/send_sats_controller.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class SendSatsFlow extends ConsumerWidget {
  const SendSatsFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider(
      kSendSatsFlowPageViewId,
    ));
    ref.watch(sendSatsControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        SendSatsDestinationScreen(),
        SendSatsAmountScreen(),
        SendSatsOverviewScreen(),
        SendSatsCompletedScreen(),
      ],
    );
  }
}
