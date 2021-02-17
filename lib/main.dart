import 'package:currency_converter/blocs/currencies_bloc.dart';
import 'package:currency_converter/blocs/quotes_bloc.dart';
import 'package:currency_converter/view/data_initializer.dart';
import 'package:flutter/material.dart';
import 'package:currency_converter/view/currency.dart';
import 'package:currency_converter/view/converter.dart';
import 'package:currency_converter/models/currencies.dart';
import 'package:currency_converter/models/quotes.dart';
import 'package:provider/provider.dart';
import 'package:currency_converter/models/enums/selecting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuoteBloc()),
        ChangeNotifierProvider(create: (context) => CurrencyListBloc()),
        ChangeNotifierProxyProvider<CurrencyListBloc, CurrencyModel>(
          create: (context) => CurrencyModel(),
          update: (context, bloc, currencies) {
            currencies = bloc.currencies;
            return currencies;
          },
        ),
        ChangeNotifierProxyProvider<QuoteBloc, QuoteModel>(
          create: (context) => QuoteModel(),
          update: (context, bloc, quotes) {
            quotes = bloc.quotes;
            return quotes;
          },
        ),
      ],
      child:  MaterialApp(
        title: 'Currency Converter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/currencyInit',
        routes: {
          '/currencyInit': (context) => CurrencyListInitializerView(),
          '/quoteInit': (context) => QuoteInitializerView(),
          '/convert': (context) => MyConverter(),
          '/listFrom': (context) => MyCurrencyList(selecting: Selecting.FROM),
          '/listTo': (context) => MyCurrencyList(selecting: Selecting.TO),
        },
      ),
    );
  }
}
