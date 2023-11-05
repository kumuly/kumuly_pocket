enum LocalCurrency {
  usd,
  euro,
}

extension LocalCurrencyExtension on LocalCurrency {
  String get code {
    switch (this) {
      case LocalCurrency.usd:
        return 'USD';
      case LocalCurrency.euro:
        return 'EUR';
      default:
        throw ArgumentError('Unsupported local currency');
    }
  }
}
