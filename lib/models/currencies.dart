import 'package:flutter/material.dart';

class CurrencyModel extends ChangeNotifier {
  final Map currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'BRL': 'Brazilian Real',
    'GBP': 'British Pound',
    'INR': 'Indian Rupee',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'SGD': 'Singapore Dollar',
    'JPY': 'Japanese Yen',
    'CNY': 'Chinese Yuan',
    'KRW': 'South Korean Won',
  };

  Currency currencyFrom, currencyTo;

  Currency getByPosition(int id) {
    String code = currencyNames.keys.elementAt(id);
    return Currency(id, code, currencyNames[code]);
  }

  void selectFrom(Currency currency) {
    if(currencyTo == currency) {currencyTo = null;}
    currencyFrom = currency;
    notifyListeners();
  }

  void selectTo(Currency currency) {
    if(currencyFrom == currency) {currencyFrom = null;}
    currencyTo = currency;
    notifyListeners();
  }

  void swapFromTo() {
    var currency = currencyFrom;
    currencyFrom = currencyTo;
    currencyTo = currency;
    notifyListeners();
  }
}

@immutable
class Currency {
  final int id;
  final String code;
  final String name;
  Currency(this.id, this.code, this.name);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Currency && other.id == id;
}