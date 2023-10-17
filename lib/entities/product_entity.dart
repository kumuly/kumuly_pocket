import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/enums/visibility.dart';

@immutable
class ProductEntity extends Equatable {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String? lnurlPayLink;
  final List<String> imageUrls;
  final Visibility visibility;
  final String merchantId;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const ProductEntity({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.lnurlPayLink,
    required this.imageUrls,
    required this.visibility,
    required this.merchantId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductEntity.fromDocumentSnapshot(
    DocumentSnapshot<Object?> documentSnapshot,
  ) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return ProductEntity(
      id: documentSnapshot.id,
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      lnurlPayLink: data['lnurlPayLink'] as String?,
      imageUrls:
          (data['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      visibility: Visibility.values.firstWhere(
          (element) => element.name == data['visibility'] as String),
      merchantId: data['merchantId'] as String,
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMapForCreation() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'lnurlPayLink': lnurlPayLink,
      'imageUrls': imageUrls,
      'visibility': visibility.stringValue,
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
    if (name.isNotEmpty) map['name'] = name;
    if (description.isNotEmpty) map['description'] = description;
    map['price'] = price;
    if (lnurlPayLink != null && lnurlPayLink!.isNotEmpty) {
      map['lnurlPayLink'] = lnurlPayLink;
    }
    map['imageUrls'] = imageUrls;
    if (visibility.stringValue.isNotEmpty) {
      map['visibility'] = visibility.stringValue;
    }
    if (merchantId!.isNotEmpty) {
      map['merchantId'] = merchantId;
    }

    return map;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        lnurlPayLink,
        imageUrls,
        visibility,
        merchantId,
        createdAt,
        updatedAt
      ];
}
