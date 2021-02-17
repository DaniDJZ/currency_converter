import 'dart:async';
import 'package:currency_converter/network/api_response.dart';
import 'package:currency_converter/repository/currencies_repository.dart';
import 'package:currency_converter/models/currencies.dart';
import 'package:flutter/material.dart';

class CurrencyListBloc extends ChangeNotifier {
  CurrencyListRepository _currencyListRepository;
  StreamController _currencyListController;
  CurrencyModel _currencies;

  CurrencyModel get currencies => _currencies;

  StreamSink<ApiResponse<CurrencyModel>> get currencyListSink =>
      _currencyListController.sink;

  Stream<ApiResponse<CurrencyModel>> get currencyListStream =>
      _currencyListController.stream;

  CurrencyListBloc() {
    _currencyListController = StreamController<ApiResponse<CurrencyModel>>();
    _currencyListRepository = CurrencyListRepository();
    fetchCurrencyList();
  }

  fetchCurrencyList() async {
    currencyListSink.add(ApiResponse.loading('Getting All Currencies'));
    try {
      _currencies = await _currencyListRepository.fetchCurrencyList();
      currencyListSink.add(ApiResponse.completed(_currencies));
    } catch (e) {
      currencyListSink.add(ApiResponse.error(e));
      print(e.toString());
    }
    notifyListeners();
  }

  dispose() {
    _currencyListController?.close();
    super.dispose();
  }
}