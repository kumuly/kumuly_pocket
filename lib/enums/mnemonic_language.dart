import 'package:flutter_bip39/flutter_bip39.dart' as bip39;

enum MnemonicLanguage {
  english,
  spanish,
}

extension MnemonicLanguageExtension on MnemonicLanguage {
  bip39.Language get bip39Language {
    switch (this) {
      case MnemonicLanguage.english:
        return bip39.Language.English;
      case MnemonicLanguage.spanish:
        return bip39.Language.Spanish;
      default:
        throw ArgumentError('Unsupported mnemonic language');
    }
  }
}
