import 'package:currency_converter/models/quotes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_converter/models/enums/selecting.dart';

class MyConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 30.0,
          ),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: _CurrencyButton(Selecting.FROM), flex: 2),
                Expanded(child: _InterchangeIconButton(), flex: 1),
                Expanded(child: _CurrencyButton(Selecting.TO), flex: 2),
              ]),
              SizedBox(height: 12),
              _CurrencyConvertForm(),
              SizedBox(height: 30),
              _ResultText(),
            ],
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${selecting.value}:',
            style: Theme.of(context).textTheme.headline6),
        ElevatedButton(
          onPressed: () =>
              Navigator.pushNamed(context, '/list${selecting.value}'),
          child: Consumer<QuoteModel>(builder: (context, quotes, child) {
            switch (selecting) {
              case Selecting.FROM:
                return Text(quotes?.currencyFrom?.name ?? 'Select Currency');
              case Selecting.TO:
                return Text(quotes?.currencyTo?.name ?? 'Select Currency');
              default:
                return null;
            }
          }),
        ),
      ],
    );
  }
}

class _InterchangeIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.code),
      onPressed: () {
        var quotes = context.read<QuoteModel>();
        quotes?.swapFromTo();
      },
    );
  }
}

class _CurrencyConvertForm extends StatefulWidget {
  @override
  __CurrencyConvertFormState createState() => __CurrencyConvertFormState();
}

class __CurrencyConvertFormState extends State<_CurrencyConvertForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount I have:'),
          SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter here...',
              prefixIcon: Icon(Icons.monetization_on),
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: _textController,
            validator: (text) => text.isEmpty || text.contains('-') || text.trim().contains(' ')  // Options that may invalidate the entered number
                                   ? 'Please enter a valid number here'
                                   : null,
          ),
          SizedBox(height: 12),
          Container(
            child: RaisedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState.validate()) {
                  var quotes = context.read<QuoteModel>();
                  (quotes?.currencyFrom != null) && (quotes?.currencyTo != null)
                      ? quotes?.calculate(double.parse(_textController.text))
                      : Scaffold.of(context)
                          .showSnackBar(SnackBar(
                            content: Text(
                              'Please select currencies you want to convert...',
                              style: TextStyle(fontSize: 20),
                            )));
                }
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
                child: Text('Calculate', style: TextStyle(fontSize: 20)),
              ),
            ),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class _ResultText extends StatelessWidget {
  final amountStyle = TextStyle(color: Colors.grey, fontSize: 20);
  final resultStyle = TextStyle(color: Colors.black, fontSize: 30);
  final quoteStyle = TextStyle(color: Colors.black54, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    var hasNewResult =
        context.select<QuoteModel, int>((quotes) => quotes?.hasNewResult);
    var quotes = context.read<QuoteModel>();
    var resultText;

    resultText = (hasNewResult != 0 && quotes?.currencyFrom != null && quotes?.currencyTo != null)
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${quotes?.amount?.toStringAsFixed(2)} ${quotes?.currencyFrom?.name} =',
                  style: amountStyle,
                ),
                SizedBox(height: 12),
                Text(
                  '${quotes?.result?.toStringAsFixed(2)} ${quotes?.currencyTo?.name}',
                  style: resultStyle,
                ),
                SizedBox(height: 20),
                Text(
                  '1 ${quotes?.currencyFrom?.code} = ${quotes?.getQuote()?.toStringAsFixed(2)} ${quotes?.currencyTo?.code}',
                  style: quoteStyle,
                ),
              ],
            ),
            alignment: Alignment.topLeft,
          )
        : Container();
    return resultText;
  }
}
