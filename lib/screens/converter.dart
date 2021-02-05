import 'package:currency_converter/models/quotes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_converter/models/currencies.dart';
import 'package:currency_converter/models/enums/selecting.dart';

class MyConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter', style: Theme.of(context).textTheme.headline5,),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
            children: [
              Row(
        children: [
          _CurrencyButton(Selecting.FROM),
        _InterchangeIconButton(),
        _CurrencyButton(Selecting.TO),
          ],
        ),
              _InputTextField(),
              Divider(height: 100, color: Colors.black),
              Consumer<QuoteModel>(
                builder: (context, quotes, child) => Text(quotes.valueCalculated?.toStringAsFixed(2) ?? '',
                    style: Theme.of(context).textTheme.headline2),
                ),
      ],
      ),
      ),
    );
  }
}

class _CurrencyButton extends StatelessWidget {
  final Selecting selecting;

  _CurrencyButton(this.selecting, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currencyButton;

    switch(selecting) {
      case Selecting.FROM:
        currencyButton = Column(
          children: [
            Text('From:'),
            Consumer<CurrencyModel>(
              builder: (context, currencies, child) => ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/listFROM'),
                child: Text(currencies.currencyFrom?.name ?? 'Select Currency'),
              ),
            ),
          ],
        );
        break;
      case Selecting.TO:
        currencyButton = Column(
          children: [
            Text('To:'),
            Consumer<CurrencyModel>(
              builder: (context, currencies, child) => ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/listTO'),
                child: Text(currencies.currencyTo?.name ?? 'Select Currency'),
              ),
            ),
          ],
        );
        break;
    }
    return currencyButton;
  }
}

class _InterchangeIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.code),
      onPressed: () {
        var currencies = context.read<CurrencyModel>();
        currencies.swapFromTo();
      },
    );
  }
}

class _InputTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Column(
      children: [
        Text('Amount I have:'),
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter here...',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
          ],
          controller: textController,
        ),
        RaisedButton(onPressed: () {
          var quotes = context.read<QuoteModel>();
          quotes.calculate(double.parse(textController.text));
        },
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child:
            const Text('Calculate', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }
}


