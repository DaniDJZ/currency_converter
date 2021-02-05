import 'package:flutter/material.dart';
import 'package:currency_converter/screens/currency.dart';
import 'package:currency_converter/screens/converter.dart';
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
        ChangeNotifierProvider(create: (context) => CurrencyModel()),
        ChangeNotifierProxyProvider<CurrencyModel, QuoteModel>(
          create: (context) => QuoteModel(),
          update: (context, currencies, quotes) {
            quotes.currencies = currencies;
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
        initialRoute: '/convert',
        routes: {
          '/convert': (context) => MyConverter(),
          '/listFROM': (context) => MyCurrencyList(selecting: Selecting.FROM),
          '/listTO': (context) => MyCurrencyList(selecting: Selecting.TO),
        },
      ),
    );
  }
}
