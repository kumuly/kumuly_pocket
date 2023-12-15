import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/my_posts/my_posts_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
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
      appBar: AppBar(
        backgroundColor: Palette.neutral[20],
        title: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.sort,
                      size: 20.0,
                      color: Palette.neutral[80],
                    ),
                    label: Text(
                      'Sort',
                      style: textTheme.display1(
                        Palette.neutral[80],
                        FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: kSpacing4,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.tune,
                      size: 20.0,
                      color: Palette.neutral[80],
                    ),
                    label: Text(
                      'Filters',
                      style: textTheme.display1(
                        Palette.neutral[80],
                        FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(
                  left: kSpacing1 * 1.5,
                  right: kSpacing2,
                ),
                backgroundColor: Colors.white,
              ),
              icon: Icon(
                Icons.add,
                size: 16.0,
                color: Palette.neutral[80],
              ),
              label: Text(
                'Post',
                style: textTheme.display1(
                  Palette.neutral[80],
                  FontWeight.w400,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await notifier.fetchPosts(refresh: true);
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: kSpacing1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kSpacing1 * 1.5,
              ),
              child: MyPostsList(
                myPostsListItems:
                    state.hasValue ? state.asData!.value.posts : [],
                loadMyPostsListItems: notifier.fetchPosts,
                limit: kMyPostsLimit,
                hasMore:
                    state.hasValue ? state.asData!.value.hasMorePosts : true,
                isLoading: state.isLoading,
                isLoadingError: state.hasError,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
