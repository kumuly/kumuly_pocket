enum MnemonicLength {
  words12,
  words24,
}

extension MnemonicLengthExtension on MnemonicLength {
  int get length {
    switch (this) {
      case MnemonicLength.words12:
        return 12;
      case MnemonicLength.words24:
        return 24;
      default:
        throw ArgumentError('Unsupported mnemonic length');
    }
  }
}
