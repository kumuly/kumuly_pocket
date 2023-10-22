import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/enums/visibility.dart';

@immutable
class MerchantEntity extends Equatable {
  const MerchantEntity({
    required this.name,
    this.description,
    this.logoUrl,
    this.location,
    this.mobilePhone,
    this.email,
    this.website,
    this.socials,
    required this.visibility,
    this.createdAt,
    this.updatedAt,
  });

  final String name;
  final String? description;
  final String? logoUrl;
  final LocationEntity? location;
  final String? mobilePhone;
  final String? email;
  final String? website;
  final SocialsEntity? socials;
  final Visibility visibility;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  Map<String, dynamic> toMapForCreation() {
    return {
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'mobilePhone': mobilePhone,
      'email': email,
      'website': website,
      'location': location?.toMap(),
      'socials': socials?.toMap(),
      'visibility': visibility.stringValue,
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
    if (description != null && description!.isNotEmpty) {
      map['description'] = description;
    }
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      map['logoUrl'] = logoUrl;
    }
    if (mobilePhone != null && mobilePhone!.isNotEmpty) {
      map['mobilePhone'] = mobilePhone;
    }
    if (email != null && email!.isNotEmpty) {
      map['email'] = email;
    }
    if (website != null && website!.isNotEmpty) {
      map['website'] = website;
    }
    if (location != null) map['location'] = location?.toMap();
    if (socials != null) map['socials'] = socials?.toMap();
    if (visibility.stringValue.isNotEmpty) {
      map['visibility'] = visibility.stringValue;
    }

    return map;
  }

  factory MerchantEntity.fromDocumentSnapshot(
    DocumentSnapshot<Object?> documentSnapshot,
  ) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return MerchantEntity(
      name: data['name'] as String,
      description: data['description'] as String?,
      logoUrl: data['logoUrl'] as String?,
      location: data['location'] != null
          ? LocationEntity(
              country: data['location']['country'] as String,
              state: data['location']['state'] as String,
              city: data['location']['city'] as String,
              address: data['location']['address'] as String,
            )
          : null,
      mobilePhone: data['mobilePhone'] as String?,
      email: data['email'] as String?,
      website: data['website'] as String?,
      socials: data['socials'] != null
          ? SocialsEntity(
              twitter: data['socials']['twitter'] as String?,
              facebook: data['socials']['facebook'] as String?,
              instagram: data['socials']['instagram'] as String?,
              linkedin: data['socials']['linkedin'] as String?,
            )
          : null,
      visibility: Visibility.values.firstWhere(
          (element) => element.name == data['visibility'] as String),
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  @override
  List<Object?> get props => [
        name,
        logoUrl,
        description,
        location,
        mobilePhone,
        email,
        website,
        socials,
        visibility,
        createdAt,
        updatedAt,
      ];
}

class LocationEntity extends Equatable {
  const LocationEntity({
    required this.country,
    required this.state,
    required this.city,
    required this.address,
  });

  final String country;
  final String state;
  final String city;
  final String address;

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'country': country,
      'state': state,
    };
  }

  @override
  List<Object?> get props => [country, state, city, address];
}

class SocialsEntity extends Equatable {
  const SocialsEntity({
    this.twitter,
    this.facebook,
    this.instagram,
    this.linkedin,
  });

  final String? twitter;
  final String? facebook;
  final String? instagram;
  final String? linkedin;

  Map<String, dynamic> toMap() {
    return {
      'facebook': facebook,
      'instagram': instagram,
      'linkedin': linkedin,
      'twitter': twitter,
    };
  }

  @override
  List<Object?> get props => [twitter, facebook, instagram, linkedin];
}
