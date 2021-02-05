import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_converter/models/currencies.dart';
import 'package:currency_converter/models/enums/selecting.dart';

class MyCurrencyList extends StatelessWidget {
  final Selecting selecting;

  MyCurrencyList({@required this.selecting});

  @override
  Widget build(BuildContext context) {
    var currencies = context.read<CurrencyModel>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CurrencyAppBar(selecting: this.selecting),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _CurrencyListItem(index: index, selecting: this.selecting),
              childCount: currencies.currencyNames.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyAppBar extends StatelessWidget {
  final Selecting selecting;

  _CurrencyAppBar({@required this.selecting});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(selecting.toString().replaceAll('Selecting.', '') + ' which one?', style: TextStyle(color: Colors.white),),
      floating: true,
    );
  }
}

class _SelectButton extends StatelessWidget {
  final Currency currency;
  final Selecting selecting;

  const _SelectButton({@required this.currency, @required this.selecting, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSelectedFrom = context.select<CurrencyModel, bool>(
          (currencies) => currencies.currencyFrom == currency,
    );
    var isSelectedTo = context.select<CurrencyModel, bool>(
          (currencies) => currencies.currencyTo == currency,
    );
    var flatButton;

    switch (selecting) {
      case Selecting.FROM:
        if(isSelectedFrom) {
          flatButton = FlatButton(
            onPressed: null,
            child: Text('FROM', style: TextStyle(color: Colors.blue),),
          );
        } else {
          flatButton = FlatButton(
            onPressed: () {
              var currencies = context.read<CurrencyModel>();
              currencies.selectFrom(currency);
            },
            splashColor: Colors.blue,
            child: isSelectedTo ? Text('TO', style: TextStyle(color: Colors.red,),) : Text('SELECT'),
          );
        }
        break;
      case Selecting.TO:
        if(isSelectedTo) {
          flatButton = FlatButton(
            onPressed: null,
            child: Text('TO', style: TextStyle(color: Colors.red),),
          );
        } else {
          flatButton = FlatButton(
            onPressed: () {
              var currencies = context.read<CurrencyModel>();
              currencies.selectTo(currency);
            },
            splashColor: Colors.red,
            child: isSelectedFrom ? Text('FROM', style: TextStyle(color: Colors.blue),) : Text('SELECT'),
          );
        }
        break;
    }
    return flatButton;
  }
}

class _CurrencyListItem extends StatelessWidget {
  final int index;
  final Selecting selecting;

  _CurrencyListItem({@required this.index, @required this.selecting, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currency = context.select<CurrencyModel, Currency>(
        (currencies) => currencies.getByPosition(index),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            Container(
              child: Text(currency.code),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Text(currency.name, style: Theme.of(context).textTheme.headline6),
            ),
            SizedBox(width: 24),
            _SelectButton(currency: currency, selecting: this.selecting),
          ],
        ),
      ),
    );
  }
}