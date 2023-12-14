import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/view_models/my_posts_list_item.dart';

@immutable
class MyPostsState extends Equatable {
  const MyPostsState({
    this.posts = const [],
    this.postsOffset = 0,
    required this.postsLimit,
    this.hasMorePosts = true,
  });

  final List<MyPostsListItem> posts; // Todo: use Posts view model
  final int postsOffset;
  final int postsLimit;
  final bool hasMorePosts;

  MyPostsState copyWith({
    List<MyPostsListItem>? posts,
    int? postsOffset,
    int? postsLimit,
    bool? hasMorePosts,
  }) {
    return MyPostsState(
      posts: posts ?? this.posts,
      postsOffset: postsOffset ?? this.postsOffset,
      postsLimit: postsLimit ?? this.postsLimit,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
    );
  }

  @override
  List<Object?> get props => [
        posts,
        postsOffset,
        postsLimit,
        hasMorePosts,
      ];
}
