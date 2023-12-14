import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/promo_type.dart';

@immutable
class Promo extends Equatable {
  const Promo({
    this.id,
    required this.type,
    required this.tag,
    required this.images,
    required this.originalPrice,
    required this.discountValue,
    required this.headline,
    required this.description,
    required this.termsAndConditions,
    required this.merchant,
    required this.lnurlPayLink,
    required this.expiry,
  });

  final String? id;
  final PromoType type;
  final String tag;
  final List<Image> images;
  final double originalPrice;
  final double discountValue;
  final String headline;
  final String description;
  final List<String> termsAndConditions;
  final PromoMerchant merchant;
  final String lnurlPayLink;
  final int expiry; // timestamp in seconds

  double get discountedPrice {
    switch (type) {
      case PromoType.percentage:
        return originalPrice - (originalPrice * (discountValue / 100));
      case PromoType.fixed:
        return originalPrice - discountValue;
      case PromoType.buyOneGetOne:
        return originalPrice; // same price, but you get more items
      case PromoType.freeItem:
        return originalPrice; // no price deduction, but you get a free item
      default:
        return originalPrice;
    }
  }

  String get expiryDate {
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(
      expiry * 1000,
    );

    return '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';
  }

  int get daysLeft {
    final now = DateTime.now();
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(
      expiry * 1000,
    );

    return expiryDate.difference(now).inDays;
  }

  @override
  List<Object?> get props => [
        id,
        type,
        tag,
        images,
        originalPrice,
        discountValue,
        headline,
        description,
        termsAndConditions,
        merchant,
        lnurlPayLink,
        expiry,
      ];
}

@immutable
class PromoMerchant extends Equatable {
  const PromoMerchant({
    required this.id,
    required this.logo,
    required this.name,
    required this.verified,
    required this.rating,
    required this.address,
    required this.distance,
  });

  final String id;
  final Image logo;
  final String name;
  final bool verified;
  final double rating;
  final String address;
  final String distance;

  @override
  List<Object?> get props => [
        id,
        logo,
        name,
        verified,
        rating,
        address,
        distance,
      ];
}
