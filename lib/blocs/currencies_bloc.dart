import 'dart:async';
import 'package:currency_converter/network/api_response.dart';
import 'package:currency_converter/repository/currencies_repository.dart';
import 'package:currency_converter/models/currencies.dart';
import 'package:currency_converter/services/local_storage.dart';
import 'package:flutter/material.dart';

class CurrencyListBloc extends ChangeNotifier {
  CurrencyListRepository _currencyListRepository;
  StreamController _currencyListController;
  CurrencyModel _currencies;
  SharedPrefs _sharedPrefs = SharedPrefs();

  CurrencyModel get currencies => _currencies;

  StreamSink<ApiResponse<CurrencyModel>> get currencyListSink =>
      _currencyListController.sink;

  Stream<ApiResponse<CurrencyModel>> get currencyListStream =>
      _currencyListController.stream;

  CurrencyListBloc() {
    _currencyListController = StreamController<ApiResponse<CurrencyModel>>();
    _currencyListRepository = CurrencyListRepository();
  }

  fetchCurrencyList() async {
    currencyListSink.add(ApiResponse.fetching('Getting All Currencies'));
    try {
      _currencies = await _currencyListRepository.fetchCurrencyList();
      _sharedPrefs.set('currencies', _currencies.toJson());
      if (await _sharedPrefs.contains('favorites')) {
        _currencies.loadFavorite(await _sharedPrefs.get('favorites'));
      }
      currencyListSink.add(ApiResponse.completed(_currencies));
    } catch (e) {
      currencyListSink.add(ApiResponse.error(e));
      print(e.toString());
    }
  }

  loadSharedPrefs() async {
    currencyListSink.add(ApiResponse.fetching('Getting Data\nFrom Local Storage...'));
    try {
      _currencies = CurrencyModel.fromJson(await _sharedPrefs.get('currencies'));
      if (await _sharedPrefs.contains('favorites')) {
        _currencies.loadFavorite(await _sharedPrefs.get('favorites'));
      }
      currencyListSink.add(ApiResponse.loaded(_currencies));
    } catch (e) {
      currencyListSink.add(ApiResponse.error(e));
      print(e.toString());
    }
  }

  dispose() {
    _currencyListController?.close();
    super.dispose();
  }
}