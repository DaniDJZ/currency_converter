import 'package:currency_converter/network/api_base.dart';
import 'dart:async';
import 'package:currency_converter/models/quotes.dart';

class QuoteRepository {
  ApiBase _apiBase = ApiBase();

  Future<QuoteModel> fetchQuote() async {
    final response = await _apiBase.get('live');
    return QuoteModel.fromJson(response);
  }
}