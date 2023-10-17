import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/product_entity.dart';
import 'package:kumuly_pocket/enums/visibility.dart';

@immutable
class PromoEntity extends Equatable {
  final String? id;
  final String description;
  final double price;
  final String lnurlPayLink;
  final List<String> imageUrls;
  final Timestamp expiryDate;
  final Visibility visibility;
  final List<ProductEntity>? products;
  final String merchantId;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const PromoEntity({
    this.id,
    required this.description,
    required this.price,
    required this.lnurlPayLink,
    required this.imageUrls,
    required this.expiryDate,
    required this.visibility,
    this.products,
    required this.merchantId,
    this.createdAt,
    this.updatedAt,
  });

  factory PromoEntity.fromDocumentSnapshot(
    DocumentSnapshot<Object?> documentSnapshot,
  ) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return PromoEntity(
      id: documentSnapshot.id,
      description: data['description'] as String,
      price: data['price'] as double,
      lnurlPayLink: data['lnurlPayLink'] as String,
      imageUrls:
          (data['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      expiryDate: data['expiryDate'] as Timestamp,
      visibility: Visibility.values.firstWhere(
          (element) => element.name == data['visibility'] as String),
      products: (data['products'] as List<dynamic>?)
          ?.map((e) => ProductEntity.fromDocumentSnapshot(e))
          .toList(),
      merchantId: data['merchantId'] as String,
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMapForCreation() {
    return {
      'description': description,
      'price': price,
      'lnurlPayLink': lnurlPayLink,
      'imageUrls': imageUrls,
      'expiryDate': expiryDate,
      'visibility': visibility.stringValue,
      'products': products?.map((e) => e.toMapForCreation()).toList(),
      'merchantId': merchantId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    final map = <String, dynamic>{
      // always update the updatedAt field
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // only add other fields if they are not null
    if (description.isNotEmpty) map['description'] = description;
    map['price'] = price;
    if (lnurlPayLink.isNotEmpty) map['lnurlPayLink'] = lnurlPayLink;
    map['imageUrls'] = imageUrls;
    map['expiryDate'] = expiryDate;
    if (visibility.stringValue.isNotEmpty) {
      map['visibility'] = visibility.stringValue;
    }
    if (products != null) {
      map['products'] = products?.map((e) => e.toMapForCreation()).toList();
    }
    if (merchantId!.isNotEmpty) {
      map['merchantId'] = merchantId;
    }

    return map;
  }

  @override
  List<Object?> get props => [
        id,
        description,
        price,
        lnurlPayLink,
        imageUrls,
        expiryDate,
        visibility,
        products,
        merchantId,
        createdAt,
        updatedAt
      ];
}
