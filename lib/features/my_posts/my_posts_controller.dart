import 'package:flutter/material.dart';
import 'package:kumuly_pocket/features/my_posts/my_posts_state.dart';
import 'package:kumuly_pocket/view_models/my_posts_list_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_posts_controller.g.dart';

List<MyPostsListItem> mockPosts = [
  MyPostsListItem(
    promoId: '3',
    title: 'Tapas Buffet 5 - 7pm Happy Hour promo',
    tag: 'Happy Hour',
    headline:
        'Savor limitless servings of Japanese tapas and sake between 5 PM and 7 PM.',
    image: Image.asset(
      'assets/images/dummy_promo_carousel_1.png',
      fit: BoxFit.cover,
    ),
    expiry: 1702853999,
    createdAt: 1702000000,
    nrOfViews: 1200,
    nrToRedeem: 12,
    nrRedeemed: 24,
  ),
  MyPostsListItem(
    promoId: '2',
    title: '€5 for Spring rolls appetizer with main courses',
    tag: '-30%',
    headline:
        'Spring into Savings: Enjoy Delectable Japanese Spring Rolls for Only 5 Euros!',
    image: Image.asset(
      'assets/images/dummy_spring_rolls.jpeg',
      fit: BoxFit.cover,
    ),
    expiry: 1702000000,
    createdAt: 1701000000,
    nrOfViews: 19000,
    nrToRedeem: 0,
    nrRedeemed: 77,
  ),
  MyPostsListItem(
    promoId: '1',
    title: '2 Cocktails for the price of 1',
    tag: '2x1',
    headline:
        'Double the Fun: Indulge in 2-for-1 Cocktails with Our Exclusive Promo!',
    image: Image.asset(
      'assets/images/dummy_cocktails.jpeg',
      fit: BoxFit.cover,
    ),
    expiry: 1701000000,
    createdAt: 1700500000,
    nrOfViews: 58000,
    nrToRedeem: 0,
    nrRedeemed: 54,
  ),
];

@riverpod
class MyPostsController extends _$MyPostsController {
  @override
  FutureOr<MyPostsState> build(int myPostsLimit) async {
    // Todo: get posts from API
    final posts = mockPosts;

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
          mockPosts;

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
