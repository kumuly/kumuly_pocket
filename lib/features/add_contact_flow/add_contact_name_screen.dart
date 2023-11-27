import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/rectangular_border_button.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class AddContactNameScreen extends ConsumerWidget {
  const AddContactNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    final state = ref.watch(addContactControllerProvider);
    final notifier = ref.read(addContactControllerProvider.notifier);
    final pageController = ref
        .read(pageViewControllerProvider(kAddContactFlowPageViewId).notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: pageController.previousPage,
        ),
        title: Text(
          copy.addContact,
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
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    copy.howToCallContact,
                    style: textTheme.display3(
                        Palette.neutral[70], FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kSpacing2),
                  TextField(
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.center,
                    style: textTheme.display6(
                        Palette.neutral[100], FontWeight.normal),
                    decoration: InputDecoration(
                      hintText: copy.insertContactNameHere,
                      hintStyle: textTheme.display6(
                        Palette.neutral[50],
                        FontWeight.normal,
                      ),
                      // Set the line color when the TextField is enabled but not focused
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Palette.neutral[50]!,
                        ), // Change this to your desired color
                      ),
                      // Set the line color when the TextField is focused
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Palette.neutral[100]!,
                        ), // Change this to your desired color
                      ),
                      // Set the line color when there's an error (optional)
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Palette.error[100]!,
                        ), // Change this to your desired color
                      ),
                      // Set the line color when there's an error and the field is focused (optional)
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Palette.error[50]!,
                        ), // Change this to your desired color
                      ),
                    ),
                    focusNode: state.nameFocusNode,
                    onChanged: notifier.onNameChangeHandler,
                  ),
                ],
              ),
            ),
          ),
          RectangularBorderButton(
            text: copy.confirmName,
            onPressed: state.name == null || state.name!.isEmpty
                ? null
                : () async {
                    try {
                      final savingContact = notifier.saveContact();
                      showTransitionDialog(context, copy.oneMomentPlease);
                      await savingContact;
                      state.nameFocusNode.unfocus();
                      router.pop();
                      pageController.nextPage();
                    } catch (e) {
                      print(e);
                      router.pop();
                    }
                  },
          ),
        ],
      ),
    );
  }
}
