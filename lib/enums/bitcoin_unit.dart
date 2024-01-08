enum BitcoinUnit {
  sat,
  btc,
}

extension BitcoinUnitExtension on BitcoinUnit {
  String get code {
    switch (this) {
      case BitcoinUnit.btc:
        return 'BTC';
      case BitcoinUnit.sat:
        return 'SAT';
      default:
        throw ArgumentError('Unsupported Bitcoin unit');
    }
  }

  String get symbol {
    switch (this) {
      case BitcoinUnit.btc:
        return '₿';
      case BitcoinUnit.sat:
        return '⚡';
      default:
        throw ArgumentError('Unsupported bitcoin unit');
    }
  }
}
