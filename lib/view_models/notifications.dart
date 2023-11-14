import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Notification extends Equatable {
  final String title;
  final String body;
  final String? imageUrl;
  final String? deepLink;

  const Notification({
    required this.title,
    required this.body,
    this.imageUrl,
    this.deepLink,
  });

  @override
  List<Object?> get props => [
        title,
        body,
        imageUrl,
        deepLink,
      ];
}
