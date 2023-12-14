import 'package:flutter/material.dart';
import 'package:kumuly_pocket/features/my_posts/my_posts_state.dart';
import 'package:kumuly_pocket/view_models/my_posts_list_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_posts_controller.g.dart';

@riverpod
class MyPostsController extends _$MyPostsController {
  @override
  FutureOr<MyPostsState> build(int myPostsLimit) async {
    // Todo: get posts from API
    List<MyPostsListItem> posts = [
      MyPostsListItem(
        promoId: '1',
        title: 'Tapas Buffet 5 - 7pm Happy Hour promo',
        tag: 'Happy Hour',
        headline:
            'Savor limitless servings of Japanese tapas and sake between 5 PM and 7 PM.',
        image: Image.asset(
          'assets/images/dummy_promo_carousel_1.png',
          fit: BoxFit.cover,
        ),
        expiry: 1702853999,
        createdAt: 1702853999,
        nrOfViews: 1200,
        nrToRedeem: 12,
        nrRedeemed: 24,
      ),
    ];

    return MyPostsState(
      postsLimit: myPostsLimit,
      posts: posts,
      postsOffset: posts.length,
      hasMorePosts: posts.length == myPostsLimit,
    );
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    await update((state) async {
      // Fetch posts
      List<MyPostsListItem>
          posts = /* Todo: await ref
          .read(sqliteChatServiceProvider)
          .getMostRecentPostsOfMerchant(
            limit: state.postsLimit,
            offset: refresh ? null : state.postsOffset,
          );*/
          [];

      // Update state
      return state.copyWith(
        posts: refresh
            ? posts
            : [
                ...state.posts,
                ...posts,
              ],
        postsOffset: state.postsOffset + posts.length,
        hasMorePosts: posts.length == state.postsLimit,
      );
    });
  }
}
