import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/pocket_mode/pocket_mode_menu_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ContactIdScreen extends ConsumerWidget {
  const ContactIdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final nodeId =
        ref.watch(pocketModeMenuControllerProvider).asData!.value.nodeId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          copy.contactId,
          style: textTheme.display4(
            Palette.neutral[100]!,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: router.pop,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              copy.contactIdExplanation,
              style: textTheme.body4(
                Palette.neutral[70],
                FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kSpacing3),
            Container(
              padding: const EdgeInsets.fromLTRB(
                kSpacing5,
                kSpacing2,
                kSpacing5,
                kSpacing5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kSpacing4),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 24),
                    spreadRadius: -12,
                    blurRadius: 48,
                    color: Color.fromRGBO(154, 170, 207, 0.55),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Palette.neutral[30]!, // Color of the border
                        width: 1.0, // Thickness of the border
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Palette.lilac[100],
                      ),
                      onPressed: () {
                        // Your action here
                      },
                    ),
                  ),
                  const SizedBox(
                    height: kSpacing3,
                  ),
                  Text(
                    copy.yourId,
                    style: textTheme.display1(
                      Palette.neutral[100]!,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: kSpacing1,
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: nodeId)).then(
                        (_) {
                          // Optionally, show a confirmation message to the user.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(copy.nodeIdCopied),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            nodeId,
                            style: textTheme.display2(
                              Palette.neutral[60]!,
                              FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow
                                .ellipsis, // Prevents overflow by truncating the text
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
                          Icons.copy_outlined,
                          color: Palette.neutral[70]!,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: kSpacing3,
                  ),
                  Divider(
                    color: Palette.neutral[20],
                    thickness: 1.5,
                  ),
                  const SizedBox(
                    height: kSpacing3,
                  ),
                  QrImageView(
                    padding: EdgeInsets.zero,
                    data: nodeId,
                    embeddedImage: const AssetImage(
                      'assets/icons/kumuly_pocket.png',
                    ),
                    embeddedImageStyle: const QrEmbeddedImageStyle(
                      size: Size(40, 40),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
