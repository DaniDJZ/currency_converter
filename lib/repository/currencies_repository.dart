import 'package:currency_converter/network/api_base.dart';
import 'dart:async';
import 'package:currency_converter/models/currencies.dart';

class CurrencyListRepository {
  ApiBase _apiBase = ApiBase();

  Future<CurrencyModel> fetchCurrencyList() async {
    final response = await _apiBase.get("list");
    return CurrencyModel.fromJson(response);
  }
}