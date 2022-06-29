import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:favorite_button/favorite_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockPage extends StatefulWidget {
  String ticker;
  String stockName;
  StockPage(this.ticker, this.stockName);

  @override
  State<StockPage> createState() =>
      _StockPageState(this.ticker, this.stockName);
}

class _StockPageState extends State<StockPage> {
  String ticker;
  String stockName;
  _StockPageState(this.ticker, this.stockName);

  Stock? acStock;
  StockCurrent? acCStock;

  List<String> favorites = [];

  Future _getListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final storedfavs = prefs.getStringList('favorites');
    setState(() {
      favorites = storedfavs ?? [];
    });
  }

  Future<void> _addToFavs() async {
    final prefs = await SharedPreferences.getInstance();
    print(favorites);
    await prefs.setStringList('favorites', favorites);
  }

  @override
  void initState() {
    _getListFromSharedPref();

    fetchStock(ticker).then((result) {
      setState(() {
        acStock = result;
      });
    });

    fetchCurrentStock(ticker).then((result) {
      setState(() {
        print(result);
        acCStock = result;
      });
    });
    super.initState();
  }

  Row firstLine() {
    return Row(children: [
      Text(
        (acStock?.ticker ?? '') + '    ',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      Text(
        acStock?.name ?? '',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
      )
    ]);
  }

  Row secondLine() {
    num openPrice = acCStock?.current ?? 0;
    num closePrice = acCStock?.open ?? 0;

    num diff = openPrice - closePrice;

    Text tchange;
    if (diff > 0) {
      tchange = Text(
        '+ ${double.parse((diff).toStringAsFixed(2))}',
        style: TextStyle(color: Colors.green, fontSize: 25),
      );
    } else {
      tchange = Text(
        '${double.parse((diff).toStringAsFixed(2))}',
        style: TextStyle(color: Colors.red, fontSize: 25),
      );
    }

    return Row(children: [
      Text(
        '${acCStock?.current}   ',
        style: TextStyle(color: Colors.white, fontSize: 27),
      ),
      tchange
    ]);
  }

  Row thirdLine() {
    return Row(children: [
      Text(
        'Stats',
        style: TextStyle(color: Colors.white, fontSize: 23),
      ),
    ]);
  }

  Row fourthLine() {
    var open = double.parse((acCStock?.open ?? 0).toStringAsFixed(2));
    var high = double.parse((acCStock?.high ?? 0).toStringAsFixed(2));

    return Row(children: [
      Text(
        'Open            ',
        style: TextStyle(
            color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
      ),
      Text(
        '$open             ',
        style: TextStyle(
            color: Colors.grey, fontSize: 19, fontWeight: FontWeight.w500),
      ),
      Text(
        'High      ',
        style: TextStyle(
            color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
      ),
      Text(
        '$high',
        style: TextStyle(
            color: Colors.grey, fontSize: 19, fontWeight: FontWeight.w500),
      ),
    ]);
  }

  Row fourthLineTwo() {
    var low = double.parse((acCStock?.low ?? 0).toStringAsFixed(2));
    var prev = double.parse((acCStock?.prev ?? 0).toStringAsFixed(2));

    return Row(children: [
      Text(
        'Low              ',
        style: TextStyle(
            color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
      ),
      Text(
        '$low             ',
        style: TextStyle(
            color: Colors.grey, fontSize: 19, fontWeight: FontWeight.w500),
      ),
      Text(
        'Prev      ',
        style: TextStyle(
            color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
      ),
      Text(
        '$prev',
        style: TextStyle(
            color: Colors.grey, fontSize: 19, fontWeight: FontWeight.w500),
      ),
    ]);
  }

  Row fifthLine() {
    return Row(children: [
      Text(
        'About',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ]);
  }

  Row sixthLine() {
    String startdate = acStock?.startdate ?? '';
    return Row(children: [
      Text(
        'Start Date     : ',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      Text(
        '$startdate',
        style: TextStyle(color: Colors.grey, fontSize: 15),
      ),
    ]);
  }

  Row seventhLine() {
    String industry = acStock?.industry ?? '';
    return Row(children: [
      Text(
        'Industry        : ',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      Text(
        industry,
        style: TextStyle(color: Colors.grey, fontSize: 15),
      ),
    ]);
  }

  Row eigthLine() {
    String website = acStock?.website ?? '';
    return Row(children: [
      Text(
        'Website        : ',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      Text(
        '$website',
        style: TextStyle(color: Colors.grey, fontSize: 15),
      ),
    ]);
  }

  Row ninthLine() {
    String exchange = acStock?.exchange ?? '';
    return Row(children: [
      Text(
        'Exchange     : ',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      Text(
        '$exchange',
        style: TextStyle(color: Colors.grey, fontSize: 15),
      ),
    ]);
  }

  Row tenthLine() {
    num marketcap = acStock?.marketcap ?? 0;
    return Row(children: [
      Text(
        'Market Cap  : ',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      Text(
        '$marketcap',
        style: TextStyle(color: Colors.grey, fontSize: 15),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    print(favorites);
    print('$ticker|$stockName');
    bool inFavs = favorites.contains('$ticker|$stockName');
    // print(inFavs);
    // print(favorites);
    print(inFavs);
    if (((acStock?.ticker ?? '') == '') || ((acStock?.name ?? '') == '')) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.grey, //change your color here
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: const Color.fromARGB(246, 12, 12, 12),
          title: const Text(
            'Details',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            StarButton(
              isStarred: inFavs,
              // iconDisabledColor: Colors.white,
              valueChanged: (_isStarred) {
                if ((_isStarred == true) && (inFavs == false)) {
                  favorites.add('$ticker|$stockName');
                  setState(() {
                    _addToFavs();
                    build(context);
                  });
                }
                // print('Is Starred : $_isStarred');
              },
            )
          ],
        ),
        body: Ink(
          color: Colors.black,
          child: SizedBox(
            height: 800,
            child: Align(
              alignment: Alignment.center,
              child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  tileColor: Colors.black,
                  textColor: Colors.white,
                  title: Text(
                    'Failed to fetch stock data!',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: 12),
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.grey, //change your color here
            ),
            backgroundColor: const Color.fromARGB(246, 12, 12, 12),
            title: const Text(
              'Details',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              StarButton(
                isStarred: inFavs,
                // iconDisabledColor: Colors.white,
                valueChanged: (_isStarred) {
                  if ((_isStarred == true) && (inFavs == false)) {
                    favorites.add('$ticker|$stockName');
                    setState(() {
                      _addToFavs();
                      build(context);
                    });
                  } else if ((_isStarred == false) && (inFavs == true)) {
                    favorites.remove('$ticker|$stockName');
                    setState(() {
                      _addToFavs();
                      build(context);
                    });
                  }
                  // print('Is Starred : $_isStarred');
                },
              )
            ],
          ),
          body: Column(
            children: [
              firstLine(),
              SizedBox(
                height: 17,
              ),
              secondLine(),
              SizedBox(
                height: 17,
              ),
              thirdLine(),
              SizedBox(
                height: 7,
              ),
              fourthLine(),
              fourthLineTwo(),
              SizedBox(
                height: 17,
              ),
              fifthLine(),
              SizedBox(
                height: 7,
              ),
              sixthLine(),
              seventhLine(),
              eigthLine(),
              ninthLine(),
              tenthLine()
            ],
          )),
    );
  }
}

class Stock {
  final String country;
  final String currency;
  final String name;
  final String ticker;
  final double price;
  final String startdate;
  final String industry;
  final String website;
  final String exchange;
  final num marketcap;

  const Stock({
    required this.country,
    required this.currency,
    required this.name,
    required this.ticker,
    required this.price,
    required this.startdate,
    required this.industry,
    required this.website,
    required this.exchange,
    required this.marketcap,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    try {
      return Stock(
          country: json['country'],
          currency: json['currency'],
          name: json['name'],
          ticker: json['ticker'],
          price: json['marketCapitalization'] / json['shareOutstanding'],
          startdate: json['ipo'],
          industry: json['finnhubIndustry'],
          website: json['weburl'],
          exchange: json['exchange'],
          marketcap: json['marketCapitalization']);
    } catch (e) {
      throw Exception();
    }
  }
}

Future<Stock?> fetchStock(String stockname) async {
  final response = await http.get(Uri.parse(
      'https://finnhub.io/api/v1/stock/profile2?symbol=$stockname&token=c9kbtl2ad3i81ufrs04g'));

  if (response.statusCode == 200) {
    try {
      return Stock.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  } else {
    return null;
    throw Exception('Failed to fetch Stock Data');
  }
}

class StockCurrent {
  final num current;
  final num open;
  final num high;
  final num low;
  final num prev;

  const StockCurrent({
    required this.current,
    required this.open,
    required this.high,
    required this.low,
    required this.prev,
  });

  factory StockCurrent.fromJson(Map<String, dynamic> json) {
    try {
      return StockCurrent(
        current: json['c'],
        open: json['o'],
        high: json['h'],
        low: json['l'],
        prev: json['pc'],
      );
    } catch (e) {
      throw Exception();
    }
  }
}

Future<StockCurrent?> fetchCurrentStock(String stockname) async {
  final response = await http.get(Uri.parse(
      'https://finnhub.io/api/v1/quote?symbol=$stockname&token=c9kbtl2ad3i81ufrs04g'));

  if (response.statusCode == 200) {
    return StockCurrent.fromJson(jsonDecode(response.body));
  } else {
    return null;
    throw Exception('Failed to fetch Stock Data');
  }
}
