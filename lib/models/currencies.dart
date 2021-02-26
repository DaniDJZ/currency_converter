import 'package:flutter/material.dart';

class CurrencyModel extends ChangeNotifier {
  final Map<String, String> currencyNames;
  final bool success;

  CurrencyModel({this.currencyNames, this.success});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      success: json['success'],
      currencyNames: json['currencies'] != null
          ? new Map<String, String>.from(json['currencies'])
          : null,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'success': success,
        'currencies': currencyNames,
      };

  Map<String, dynamic> favoriteToJson() =>
      {
        'favorites': favoriteCurrency.map((currency) => currency.id).toList(),
      };

  void loadFavorite(Map<String, dynamic> json) {
    var favorites = json['favorites'];
    favoriteCurrency = favorites != null
        ? List.from(favorites).map((id) => getByPosition(id)).toList()
        : [];
  }

  List<Currency> favoriteCurrency = [];

  Currency getByPosition(int id) {
    String code = currencyNames.keys.elementAt(id);
    return Currency(id, code, currencyNames[code]);
  }

  void addFavorite(Currency currency) {
    favoriteCurrency.add(currency);
    notifyListeners();
  }

  void removeFavorite(Currency currency) {
    favoriteCurrency.remove(currency);
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