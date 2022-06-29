import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe/swipe.dart';
import 'package:trialapp/screens/search_page.dart';
import 'package:trialapp/screens/stock_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recase/recase.dart';
import 'dart:convert';

final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('MMMM dd');
final String formattedDate = formatter.format(now);

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> favorites = [];
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Stock');

  @override
  void initState() {
    print('Initi');
    super.initState();
    _setListFromSharedPref();
  }

  // Future<void> _resetCounter() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setStringList('favorites', favorites);
  //   }

  Future<void> _addToFavs() async {
    print('Baba');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favorites);
  }

  Future _setListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final storedfavs = prefs.getStringList('favorites');
    print('Stored');
    if (storedfavs == null) {
      await prefs.setStringList('favorites', []);
      setState(() {
        favorites = [];
      });
    } else {
      setState(() {
        favorites = storedfavs;
      });
    }
  }

  void onGoBack(dynamic value) {
    _setListFromSharedPref();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print('favorites');
    print(favorites);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: customSearchBar,
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ).then(onGoBack);
            },
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(14),
                child: Text(
                  'STOCK WATCH\n$formattedDate',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 0.7),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(14),
                child: Text(
                  'Favourites',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 0.7),
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                height: 0,
                child: Divider(
                  color: Colors.white,
                  thickness: 2,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 12),
          child: Column(
            children: <Widget>[
              for (var s in favorites)
                Swipe(
                  onSwipeLeft: () {
                    favorites.remove(s);
                    _addToFavs();
                    setState(() {});
                  },
                  onSwipeRight: () {
                    favorites.remove(s);
                    _addToFavs();
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.white),
                      ),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StockPage(
                                  s.substring(0, s.indexOf("|")).trim(),
                                  s.substring(s.indexOf("|") + 1).trim())),
                        ).then(onGoBack);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          tileColor: Colors.black,
                          textColor: Colors.white,
                          title: Text(s.substring(0, s.indexOf("|")).trim() +
                              ' \n' +
                              s.substring(s.indexOf("|") + 1).trim()),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
      ]),
    );
  }
}
