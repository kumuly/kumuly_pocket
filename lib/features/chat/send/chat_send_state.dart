import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ChatSendState extends Equatable {
  const ChatSendState({
    this.amountSat,
    this.memo,
    this.amountInputError,
    this.memoInputError,
    this.isSending = false,
  });

  final int? amountSat;
  final String? memo;
  final Error? amountInputError, memoInputError;
  final bool isSending;

  ChatSendState copyWith({
    int? amountSat,
    String? memo,
    Error? amountInputError,
    Error? memoInputError,
    bool? isSending,
  }) {
    return ChatSendState(
      amountSat: amountSat ?? this.amountSat,
      memo: memo ?? this.memo,
      amountInputError: amountInputError ?? this.amountInputError,
      memoInputError: memoInputError ?? this.memoInputError,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [
        amountSat,
        memo,
        amountInputError,
        memoInputError,
        isSending,
      ];
}
