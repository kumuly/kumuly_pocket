import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class FrequentContactItem extends Equatable {
  const FrequentContactItem({
    required this.contactId,
    required this.contactName,
    this.contactImagePath,
  });

  final int contactId;
  final String contactName;
  final String? contactImagePath;

  @override
  List<Object?> get props => [
        contactId,
        contactName,
        contactImagePath,
      ];
}
