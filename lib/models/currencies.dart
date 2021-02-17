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

  List<Currency> favoriteCurrency = [];

  Currency getByPosition(int id) {
    String code = currencyNames.keys.elementAt(id);
    return Currency(id, code, currencyNames[code]);
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