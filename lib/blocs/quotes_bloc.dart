import 'dart:async';
import 'package:currency_converter/network/api_response.dart';
import 'package:currency_converter/repository/quotes_repository.dart';
import 'package:currency_converter/models/quotes.dart';
import 'package:flutter/material.dart';

class QuoteBloc extends ChangeNotifier {
  QuoteRepository _quoteRepository;
  StreamController _quoteDataController;
  QuoteModel _quotes;

  QuoteModel get quotes => _quotes;

  StreamSink<ApiResponse<QuoteModel>> get quoteDataSink =>
      _quoteDataController.sink;

  Stream<ApiResponse<QuoteModel>> get quoteDataStream =>
      _quoteDataController.stream;

  QuoteBloc() {
    _quoteDataController = StreamController<ApiResponse<QuoteModel>>();
    _quoteRepository = QuoteRepository();
    fetchQuote();
  }

  fetchQuote() async {
    quoteDataSink.add(ApiResponse.loading('Getting Exchange Rates'));
    try {
      _quotes = await _quoteRepository.fetchQuote();
      quoteDataSink.add(ApiResponse.completed(_quotes));
    } catch (e) {
      quoteDataSink.add(ApiResponse.error(e));
      print(e.toString());
    }
    notifyListeners();
  }

  dispose() {
    _quoteDataController?.close();
    super.dispose();
  }
}