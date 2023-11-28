import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/chat/chat_controller.dart';
import 'package:kumuly_pocket/features/chat/chat_messages_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/backgrounds/background_container.dart';
import 'package:kumuly_pocket/widgets/buttons/expandable_fab.dart';
import 'package:kumuly_pocket/widgets/buttons/rectangular_border_button.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/chat_messages_list.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    final chatState = ref.watch(chatControllerProvider(id));

    const messagesLimit = 20;
    final messagesState =
        ref.watch(chatMessagesControllerProvider(id, messagesLimit));
    final messagesNotifier =
        ref.read(chatMessagesControllerProvider(id, messagesLimit).notifier);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 88,
        backgroundColor: Colors.white,
        title: Row(children: [
          CircleAvatar(
            backgroundColor: Palette.neutral[30],
            radius: 20,
            child: const Icon(
              Icons.person,
              color: Colors.black,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              chatState.asData?.value.contactName ?? id,
              style: textTheme.display3(
                Palette.neutral[100],
                FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: Palette.neutral[70],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: BackgroundContainer(
        appBarHeight: 0,
        assetName: 'assets/backgrounds/chat_background.png',
        color: Palette.neutral[20],
        child: ChatMessagesList(
          limit: messagesLimit,
          chatMessages: messagesState.hasValue
              ? messagesState.asData!.value.messages
              : [],
          loadChatMessages: messagesNotifier.fetchMessages,
          hasMore: messagesState.hasValue
              ? messagesState.asData!.value.hasMoreMessages
              : true,
          isLoading: messagesState.isLoading,
          isLoadingError: messagesState.hasError,
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 72,
        children: [
          ActionButton(
            onPressed: () {
              showModalBottomSheet(
                elevation: 0,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Palette.neutral[40]!, width: 1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                context: context,
                builder: (context) {
                  // Calculate the keyboard height
                  final double keyboardHeight =
                      MediaQuery.of(context).viewInsets.bottom;

                  return GestureDetector(
                    onVerticalDragStart: (_) =>
                        FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              keyboardHeight, // Dynamic padding based on keyboard height
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(
                                    0.92), // Semi-transparent white
                                Colors.white,
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            border: Border.all(
                                color: Palette.neutral[40]!, width: 1),
                          ),
                          // Your modal content goes here
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: 0,
                                child: CloseButton(
                                  style: ButtonStyle(
                                    iconSize:
                                        MaterialStateProperty.all(kSpacing2),
                                    iconColor: MaterialStateProperty.all(
                                      Palette.neutral[70],
                                    ),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(kSpacing1),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: kSpacing3,
                                      left: kSpacing3,
                                    ),
                                    child: Text(
                                      'Pocket balance: 5.000.000 SAT'
                                          .toUpperCase(),
                                      style: textTheme.caption1(
                                        Palette.neutral[50],
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 53),
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: kSpacing3,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Amount to send',
                                            style: textTheme.display2(
                                              Palette.neutral[80],
                                              FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: kSpacing2),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IntrinsicWidth(
                                                child: TextField(
                                                  autofocus: true,
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(
                                                    decimal: true,
                                                  ),
                                                  style: textTheme.display7(
                                                    Palette.neutral[120],
                                                    FontWeight.w600,
                                                  ),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: '0',
                                                    hintStyle:
                                                        textTheme.display7(
                                                      Palette.neutral[40],
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                  onChanged: null,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: kSpacing1 / 2,
                                              ), // Adjust the width value for the desired spacing
                                              Text(
                                                'SAT',
                                                style: textTheme.display2(
                                                  Palette.neutral[70],
                                                  FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '≈ 50 EUR',
                                            style: textTheme.display1(
                                              Palette.neutral[60],
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: kSpacing9,
                                  ),
                                  Center(
                                    child: DashedDivider(
                                      length: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  SizedBox(
                                    height: kSpacing17,
                                    child: TextField(
                                      maxLines: 3,
                                      autofocus: true,
                                      keyboardType: TextInputType.text,
                                      style: textTheme.body3(
                                        Palette.neutral[70],
                                        FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Add a note here',
                                        hintStyle: textTheme.body3(
                                          Palette.neutral[50],
                                          FontWeight.w400,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                          kSpacing3,
                                          kSpacing2,
                                          kSpacing3,
                                          kSpacing5,
                                        ),
                                      ),
                                      onChanged: null,
                                    ),
                                  ),
                                  RectangularBorderButton(
                                    text: 'Send funds',
                                    borderColor: Palette.neutral[30]!,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon: const DynamicIcon(
              icon: 'assets/icons/send_coins.svg',
              color: Colors.white,
              size: 24,
            ),
          ),
          ActionButton(
            onPressed: () {},
            icon: const DynamicIcon(
              icon: 'assets/icons/request_coins.svg',
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
