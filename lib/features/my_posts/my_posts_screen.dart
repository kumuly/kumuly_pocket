import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/my_posts/my_posts_controller.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/lists/my_posts_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPostsScreen extends ConsumerWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;

    final state = ref.watch(
      myPostsControllerProvider(kMyPostsLimit),
    );
    final notifier = ref.read(
      myPostsControllerProvider(kMyPostsLimit).notifier,
    );

    return Scaffold(
      backgroundColor: Palette.neutral[20],
      body: Padding(
        padding: const EdgeInsets.only(
          top: kSpacing6,
        ),
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await notifier.fetchPosts(refresh: true);
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSpacing2,
                    ),
                    child: MyPostsList(
                      myPostsListItems:
                          state.hasValue ? state.asData!.value.posts : [],
                      loadMyPostsListItems: notifier.fetchPosts,
                      limit: kMyPostsLimit,
                      hasMore: state.hasValue
                          ? state.asData!.value.hasMorePosts
                          : true,
                      isLoading: state.isLoading,
                      isLoadingError: state.hasError,
                    ),
                  ),
                  const SizedBox(
                    height: kSpacing3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
