import 'package:kumuly_pocket/enums/mnemonic_language.dart';

abstract class WalletService {
  Future<void> createWallet();
}

class BitcoinWalletService implements WalletService {
  @override
  Future<void> createWallet() {
    // TODO: implement createWallet
    throw UnimplementedError();
  }
}
