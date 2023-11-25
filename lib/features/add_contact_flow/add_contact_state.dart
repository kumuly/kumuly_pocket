import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class AddContactState extends Equatable {
  const AddContactState({
    this.id,
    required this.idFocusNode,
    required this.idTextController,
    this.idInputError,
    this.name,
    required this.nameFocusNode,
    this.nameInputError,
    this.avatarImagePath,
  });

  final String? id;
  final FocusNode idFocusNode;
  final TextEditingController idTextController;
  final Error? idInputError;
  final String? name;
  final FocusNode nameFocusNode;
  final Error? nameInputError;
  final String? avatarImagePath;

  AddContactState copyWith({
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
