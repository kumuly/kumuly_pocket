import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class AddContactState extends Equatable {
  const AddContactState({
    this.contactId,
    this.id,
    required this.idFocusNode,
    required this.idTextController,
    this.idInputError,
    this.name,
    required this.nameFocusNode,
    this.nameInputError,
    this.avatarImagePath,
  });

  final int? contactId;
  final String?
      id; // Can be a nodeId, bolt12, lightningAddress or bitcoinAddress. Todo: rename to staticPaymentId
  final FocusNode idFocusNode;
  final TextEditingController idTextController;
  final Error? idInputError;
  final String? name;
  final FocusNode nameFocusNode;
  final Error? nameInputError;
  final String? avatarImagePath;

  AddContactState copyWith({
    int? contactId,
    String? id,
    FocusNode? idFocusNode,
    TextEditingController? idTextController,
    Error? idInputError,
    String? name,
    FocusNode? nameFocusNode,
    Error? nameInputError,
    String? avatarImagePath,
  }) {
    return AddContactState(
      contactId: contactId ?? this.contactId,
      id: id ?? this.id,
      idFocusNode: idFocusNode ?? this.idFocusNode,
      idTextController: idTextController ?? this.idTextController,
      idInputError: idInputError ?? this.idInputError,
      name: name ?? this.name,
      nameFocusNode: nameFocusNode ?? this.nameFocusNode,
      nameInputError: nameInputError ?? this.nameInputError,
      avatarImagePath: avatarImagePath ?? this.avatarImagePath,
    );
  }

  @override
  List<Object?> get props => [
        contactId,
        id,
        idFocusNode,
        idTextController,
        idInputError,
        name,
        nameFocusNode,
        nameInputError,
        avatarImagePath,
      ];
}
