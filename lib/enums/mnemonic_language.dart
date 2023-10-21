import 'package:bip39_mnemonic/bip39_mnemonic.dart' as bip39;

enum MnemonicLanguage {
  english,
  spanish,
}

extension MnemonicLanguageExtension on MnemonicLanguage {
  bip39.Language get bip39Language {
    switch (this) {
      case MnemonicLanguage.english:
        return bip39.Language.english;
      case MnemonicLanguage.spanish:
        return bip39.Language.spanish;
      default:
        throw ArgumentError('Unsupported mnemonic language');
    }
  }
}
