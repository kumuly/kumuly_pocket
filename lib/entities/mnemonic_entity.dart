import 'package:kumuly_pocket/enums/mnemonic_language.dart';

class MnemonicEntity {
  final List<String> words;
  final MnemonicLanguage language;

  MnemonicEntity({required this.words, required this.language});
}
