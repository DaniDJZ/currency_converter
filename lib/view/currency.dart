import 'package:currency_converter/models/quotes.dart';
import 'package:currency_converter/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_converter/models/currencies.dart';
import 'package:currency_converter/models/enums/selecting.dart';
import 'dart:async';

class MyCurrencyList extends StatefulWidget {
  final Selecting selecting;
  MyCurrencyList({@required this.selecting});

  @override
  _MyCurrencyListState createState() => _MyCurrencyListState();
}

class Delayer {
  final int milliseconds;
  Timer _timer;

  Delayer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _MyCurrencyListState extends State<MyCurrencyList> {
  final textController = TextEditingController();
  final _delayer = Delayer(milliseconds: 500);

  void _searchCatalog() {
    _delayer.run(() {   // Wait for 0.5 seconds to search after the user types.
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(_searchCatalog);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var listLength = context.select<CurrencyModel, int>(
            (currencies) => currencies.favoriteCurrency.length + currencies.currencyNames.length
    );

    return Scaffold(
        body: GestureDetector(
          child:CustomScrollView(
            slivers: [
              _CurrencyAppBar(selecting: widget.selecting),
              _CurrencySearchForm(textController: textController),
              SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _CurrencyListItem(index: index, selecting: widget.selecting, controller: textController),
                  childCount: listLength,
                ),
              ),
            ],
          ),
          onVerticalDragCancel: () => !FocusScope.of(context).hasPrimaryFocus
                                                        ? FocusScope.of(context).unfocus()
                                                        : null,
        )
    );
  }
}

class _CurrencyAppBar extends StatelessWidget {
  final Selecting selecting;
  _CurrencyAppBar({@required this.selecting});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(selecting.value + ' which one?', style: TextStyle(color: Colors.white),),
      floating: true,
      elevation: 10,
    );
  }
}

class _CurrencySearchForm extends StatelessWidget {
  final TextEditingController textController;
  _CurrencySearchForm({this.textController});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Filter by currency name or code',
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                FocusScope.of(context).unfocus();
                textController.clear();
                },
            ),
          ),
          controller: textController,
        ),
      ),
    );
  }
}

class _SelectButton extends StatelessWidget {
  final Currency currency;
  final Selecting selecting;

  const _SelectButton({@required this.currency, @required this.selecting, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSelectedFrom = context.select<QuoteModel, bool>(
          (quotes) => quotes?.currencyFrom == currency,
    );
    var isSelectedTo = context.select<QuoteModel, bool>(
          (quotes) => quotes?.currencyTo == currency,
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
              var quotes = context.read<QuoteModel>();
              quotes?.selectFrom(currency);
            },
            splashColor: Colors.blue,
            child: isSelectedTo ? Text('TO', style: TextStyle(color: Colors.red)) : Text('SELECT'),
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
              var quotes = context.read<QuoteModel>();
              quotes?.selectTo(currency);
            },
            splashColor: Colors.red,
            child: isSelectedFrom ? Text('FROM', style: TextStyle(color: Colors.blue)) : Text('SELECT'),
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
  final TextEditingController controller;

  _CurrencyListItem({this.index, this.selecting, this.controller, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currencies = context.read<CurrencyModel>();
    var currency;
    var ind = index;

    if (ind < currencies.favoriteCurrency.length) {
      currency = currencies?.favoriteCurrency[ind];
    }
    else {
      ind = ind - currencies?.favoriteCurrency?.length;
      currency = currencies?.getByPosition(ind);
      if (currencies.favoriteCurrency.contains(currency)) {
        return Container();
      }
    }

    if (controller.text.isNotEmpty
        && !currency.name.toLowerCase().contains(controller.text.trim().toLowerCase())
        && !currency.code.toLowerCase().contains(controller.text.trim().toLowerCase())) {
      return Container();
    }

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
            _SelectButton(currency: currency, selecting: selecting),
            _FavoriteIconButton(currency: currency),
          ]
        ),
      ),
    );
  }
}

class _FavoriteIconButton extends StatelessWidget {
  final Currency currency;
  _FavoriteIconButton({@required this.currency, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var alreadyFavorite = context.select<CurrencyModel, bool>(
          (currencies) => currencies.favoriteCurrency.contains(currency)
    );
    return IconButton(
        icon: Icon(
          alreadyFavorite? Icons.favorite : Icons.favorite_border,
          color: alreadyFavorite ? Colors.red : null,
        ),
        onPressed:() {
          var currencies = context.read<CurrencyModel>();
          alreadyFavorite ? currencies.removeFavorite(currency) : currencies.addFavorite(currency);
          SharedPrefs sharedPrefs = SharedPrefs();
          sharedPrefs.set('favorites', currencies.favoriteToJson());
        }
    );
  }
}
