import 'package:flutter/material.dart';
import 'package:currency_converter/models/currencies.dart';

class QuoteModel extends ChangeNotifier {
  final Map quoteValues = {
    "USDEUR": 3.672982,
    "USDUSD": 1,
    "USDBRL": 57.8836,
    "USDGBP": 126.1652,
    "USDINR": 475.306,
    "USDAUD": 1.78952,
    "USDCAD": 109.216875,
    "USDSGD": 8.901966,
    "USDJPY": 1.269072,
    "USDCNY": 1.792375,
    "USDKRW": 1.04945,
  };

  CurrencyModel _currencies;

  CurrencyModel get currencies => _currencies;

  set currencies(CurrencyModel newCurrencies) {
    _currencies = newCurrencies;
    notifyListeners();
  }

  double valueCalculated;

  String getCodePairFrom() => 'USD' + _currencies.currencyFrom?.code;

  String getCodePairTo() => 'USD' + _currencies.currencyTo?.code;

  double getQuoteOfFromUSD() => 1/quoteValues[getCodePairFrom()].toDouble();

  double getQuoteOfUSDTo () => quoteValues[getCodePairTo()].toDouble();

  double getQuote() => getQuoteOfFromUSD()*getQuoteOfUSDTo().toDouble();

  void calculate(double amount) {
    valueCalculated = amount*getQuote().toDouble();
    notifyListeners();
  }
}