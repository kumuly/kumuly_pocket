import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_completed.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_controller.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_id_screen.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_name_screen.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class AddContactFlow extends ConsumerWidget {
  const AddContactFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider(
      kAddContactFlowPageViewId,
    ));
    ref.watch(addContactControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        AddContactIdScreen(),
        AddContactNameScreen(),
        //AddContactAvatarScreen(),
        AddContactCompletedScreen(),
      ],
    );
  }
}
