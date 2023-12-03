import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddContactCompletedScreen extends ConsumerWidget {
  const AddContactCompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    final state = ref.watch(addContactControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
              onPressed: () => router.goNamed('contacts'),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 80.0,
            backgroundColor: Palette.neutral[100],
            backgroundImage: state.avatarImagePath != null
                ? FileImage(File(state.avatarImagePath!))
                : null,
            child: state.avatarImagePath == null
                ? const Icon(
                    Icons.person,
                    size: 80.0,
                    color: Colors.white,
                  )
                : null,
          ),
          Column(
            children: [
              Text(
                copy.contactAddedSuccessfully,
                style: textTheme.display5(
                  Palette.lilac[100],
                  FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                state.name!,
                style: textTheme.display7(
                  Palette.neutral[100],
                  FontWeight.bold,
                ),
              ),
            ],
          ),
          PrimaryTextButton(
            text: copy.sendNewContact,
            trailingIcon: Icon(
              Icons.arrow_forward_ios,
              color: Palette.russianViolet[100],
              size: 16.0,
            ),
            onPressed: () => router.pushReplacementNamed(
              'chat',
              pathParameters: {
                'id': state.contactId!.toString(),
              },
            ),
          ),
        ],
      ),
    );
  }
}
