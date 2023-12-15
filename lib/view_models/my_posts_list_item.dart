import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class MyPostsListItem extends Equatable {
  const MyPostsListItem({
    required this.promoId,
    required this.title,
    required this.tag,
    required this.image,
    required this.headline,
    required this.expiry,
    required this.createdAt,
    required this.nrOfViews,
    required this.nrToRedeem,
    required this.nrRedeemed,
  });

  final String promoId;
  final String title;
  final String tag;
  final Image image;
  final String headline;
  final int expiry; // timestamp in seconds
  final int createdAt; // timestamp in seconds
  final int nrOfViews;
  final int nrToRedeem;
  final int nrRedeemed;

  String get createdAtDate {
    final createdDate = DateTime.fromMillisecondsSinceEpoch(
      createdAt * 1000,
    );

    return '${createdDate.day}/${createdDate.month}/${createdDate.year}';
  }

  int get daysLeft {
    final now = DateTime.now();
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(
      expiry * 1000,
    );

    return expiryDate.difference(now).inDays;
  }

  bool get isFinished => daysLeft < 0;

  String get views {
    if (nrOfViews == 0) {
      return '0';
    } else if (nrOfViews < 1000) {
      return nrOfViews.toString();
    } else if (nrOfViews < 1000000) {
      return '${(nrOfViews / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(nrOfViews / 1000000).toStringAsFixed(1)}M';
    }
  }

  String get toRedeem {
    if (nrToRedeem == 0) {
      return '0';
    } else if (nrToRedeem < 1000) {
      return nrToRedeem.toString();
    } else if (nrToRedeem < 1000000) {
      return '${(nrToRedeem / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(nrToRedeem / 1000000).toStringAsFixed(1)}M';
    }
  }

  String get redeemed {
    if (nrRedeemed == 0) {
      return '0';
    } else if (nrRedeemed < 1000) {
      return nrRedeemed.toString();
    } else if (nrRedeemed < 1000000) {
      return '${(nrRedeemed / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(nrRedeemed / 1000000).toStringAsFixed(1)}M';
    }
  }

  @override
  List<Object?> get props => [
        promoId,
        title,
        tag,
        image,
        headline,
        expiry,
        createdAt,
        nrOfViews,
        nrToRedeem,
        nrRedeemed,
      ];
}
