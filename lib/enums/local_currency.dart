enum LocalCurrency {
  usd,
  euro,
  gbp,
  chf,
  cad,
  aud,
  cop,
  mxn,
}

extension LocalCurrencyExtension on LocalCurrency {
  String get code {
    switch (this) {
      case LocalCurrency.usd:
        return 'USD';
      case LocalCurrency.euro:
        return 'EUR';
      case LocalCurrency.gbp:
        return 'GBP';
      case LocalCurrency.chf:
        return 'CHF';
      case LocalCurrency.cad:
        return 'CAD';
      case LocalCurrency.aud:
        return 'AUD';
      case LocalCurrency.cop:
        return 'COP';
      case LocalCurrency.mxn:
        return 'MXN';
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
      case LocalCurrency.gbp:
        return '£';
      case LocalCurrency.chf:
        return '';
      case LocalCurrency.cad:
        return '\$';
      case LocalCurrency.aud:
        return '\$';
      case LocalCurrency.cop:
        return '\$';
      case LocalCurrency.mxn:
        return '\$';
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
      case LocalCurrency.gbp:
        return 'British Pound';
      case LocalCurrency.chf:
        return 'Swiss Franc';
      case LocalCurrency.cad:
        return 'Canadian Dollar';
      case LocalCurrency.aud:
        return 'Australian Dollar';
      case LocalCurrency.cop:
        return 'Colombian Peso';
      case LocalCurrency.mxn:
        return 'Mexican Peso';
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
      case LocalCurrency.gbp:
        return '🇬🇧';
      case LocalCurrency.chf:
        return '🇨🇭';
      case LocalCurrency.cad:
        return '🇨🇦';
      case LocalCurrency.aud:
        return '🇦🇺';
      case LocalCurrency.cop:
        return '🇨🇴';
      case LocalCurrency.mxn:
        return '🇲🇽';
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
      case LocalCurrency.gbp:
        return 2;
      case LocalCurrency.chf:
        return 2;
      case LocalCurrency.cad:
        return 2;
      case LocalCurrency.aud:
        return 2;
      case LocalCurrency.cop:
        return 0;
      case LocalCurrency.mxn:
        return 2;
      default:
        throw ArgumentError('Unsupported local currency');
    }
  }
}
