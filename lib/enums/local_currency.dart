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

  String get symbol {
    switch (this) {
      case LocalCurrency.usd:
        return '\$';
      case LocalCurrency.euro:
        return '€';
      default:
        throw ArgumentError('Unsupported local currency');
    }
  }

  String get name {
    switch (this) {
      case LocalCurrency.usd:
        return 'US Dollar';
      case LocalCurrency.euro:
        return 'Euro';
      default:
        throw ArgumentError('Unsupported local currency');
    }
  }

  String get flag {
    switch (this) {
      case LocalCurrency.usd:
        return '🇺🇸';
      case LocalCurrency.euro:
        return '🇪🇺';
      default:
        throw ArgumentError('Unsupported local currency');
    }
  }

  int get decimals {
    switch (this) {
      case LocalCurrency.usd:
        return 2;
      case LocalCurrency.euro:
        return 2;
      default:
        throw ArgumentError('Unsupported local currency');
    }
  }
}
