import 'package:flutter/material.dart';
import 'package:currency_converter/models/currencies.dart';

class QuoteModel extends ChangeNotifier {
  final Map<String, dynamic> quoteValues;
  final bool success;

  QuoteModel({this.quoteValues, this.success});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      success: json['success'],
      quoteValues: json['quotes'] != null
          ? new Map<String, dynamic>.from(json['quotes'])
          : null,
    );
  }

  Currency currencyFrom, currencyTo;

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

  double amount;
  double result;
  int hasNewResult = 0;

  String getCodePairFrom() => 'USD' + currencyFrom?.code;

  String getCodePairTo() => 'USD' + currencyTo?.code;

  double getQuoteOfFromUSD() => 1/quoteValues[getCodePairFrom()].toDouble();

  double getQuoteOfUSDTo () => quoteValues[getCodePairTo()].toDouble();

  double getQuote() => getQuoteOfFromUSD()*getQuoteOfUSDTo().toDouble();

  void calculate(double newAmount) {
    amount = newAmount;
    result = newAmount*getQuote().toDouble();
    hasNewResult++;
    notifyListeners();
  }
}
