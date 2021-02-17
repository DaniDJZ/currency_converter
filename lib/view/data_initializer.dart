import 'package:currency_converter/blocs/currencies_bloc.dart';
import 'package:currency_converter/blocs/quotes_bloc.dart';
import 'package:currency_converter/models/quotes.dart';
import 'package:currency_converter/network/api_exception.dart';
import 'package:currency_converter/network/api_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_converter/models/currencies.dart';
import 'package:currency_converter/view/converter.dart';

class CurrencyListInitializerView extends StatefulWidget {
  @override
  _CurrencyListInitializerViewState createState() => _CurrencyListInitializerViewState();
}

class _CurrencyListInitializerViewState extends State<CurrencyListInitializerView> {
  CurrencyListBloc _currencyListBloc;

  @override
  void initState() {
    super.initState();
    _currencyListBloc = context.read<CurrencyListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Currency Converter',
          style: Theme.of(context).textTheme.headline5,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 10,
      ),
      body: StreamBuilder<ApiResponse<CurrencyModel>>(
          stream: _currencyListBloc.currencyListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return _Loading(message: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return QuoteInitializerView();
                  break;
                case Status.ERROR:
                  return _Error(
                    errorResponse: snapshot.data,
                    onRetryPressed: () => _currencyListBloc.fetchCurrencyList(),
                  );
                  break;
              }
            }
            return Container();
          }),
    );
  }

  @override
  void dispose() {
    _currencyListBloc.dispose();
    super.dispose();
  }
}

class QuoteInitializerView extends StatefulWidget {
  @override
  _QuoteInitializerViewState createState() => _QuoteInitializerViewState();
}

class _QuoteInitializerViewState extends State<QuoteInitializerView> {
  QuoteBloc _quoteBloc;

  @override
  void initState() {
    super.initState();
    _quoteBloc = context.read<QuoteBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<ApiResponse<QuoteModel>>(
          stream: _quoteBloc.quoteDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return _Loading(message: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return MyConverter();
                  break;
                case Status.ERROR:
                  return _Error(
                    errorResponse: snapshot.data,
                    onRetryPressed: () => _quoteBloc.fetchQuote(),
                  );
                  break;
              }
            }
            return Container();
          }
      ),
    );
  }

  @override
  void dispose() {
    _quoteBloc.dispose();
    super.dispose();
  }
}

class _Loading extends StatelessWidget {
  final String message;
  _Loading({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final ApiResponse errorResponse;
  final Function onRetryPressed;
  _Error({this.errorResponse, this.onRetryPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Oops...\nSomething went wrong!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Text(
            errorResponse.error is NoInternetException
                ? '\n${errorResponse.error.toString()}\nand Retry!'
                : '\nPlease Retry!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(height: 12),
          RaisedButton(
            color: Colors.blue,
            child: Text('Retry', style: TextStyle(color: Colors.white)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}