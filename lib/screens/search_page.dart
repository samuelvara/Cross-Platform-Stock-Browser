import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trialapp/screens/stock_page.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<List> temp = <List>[];
  String searchstr = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.grey, //change your color here
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: const Color.fromARGB(246, 12, 12, 12),
            // The search area here
            title: SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                  child: TextField(
                      controller: _controller,
                      cursorColor: Colors.purple,
                      cursorHeight: 23,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (String value) {
                        fetchStockResponse(value).then((result) {
                          setState(() {
                            searchstr = value;
                            if (result.isEmpty) {
                              temp = [];
                            } else {
                              temp = result;
                            }
                            // print(temp);
                          });
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        suffixIcon: IconTheme(
                          data: const IconThemeData(color: Colors.grey),
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _controller.clear,
                          ),
                        ),
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ))),
            )),
        body: ListView(children: <Widget>[
          if ((temp.isEmpty) || (searchstr == ''))
            Ink(
              color: Colors.black,
              child: SizedBox(
                height: 1000,
                child: Align(
                  alignment: Alignment.center,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      tileColor: Colors.black,
                      textColor: Colors.white,
                      title: Text(
                        'No Suggestions Found!',
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            for (var stocdesc in temp)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StockPage(stocdesc[1], stocdesc[0])),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0),
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    tileColor: Colors.black,
                    textColor: Colors.white,
                    title: Text(stocdesc[1] + ' | ' + stocdesc[0]),
                  ),
                ),
              ),
        ]));
  }
}

class StockResponse {
  final String symbol;
  final String description;

  const StockResponse({
    required this.symbol,
    required this.description,
  });
}

Future<List<List>> fetchStockResponse(String typedvalue) async {
  final response = await http.get(Uri.parse(
      'https://finnhub.io/api/v1/search?q=$typedvalue&token=c9kbtl2ad3i81ufrs04g'));

  if (response.statusCode == 200) {
    // return response;
    return availStocks(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load stock');
  }
}

List<List> availStocks(Map<String, dynamic> json) {
  int count = json['count'];
  List<List> stocklist = <List>[];

  if (count > 0) {
    for (var stock in json['result']) {
      List<String> data = <String>[];
      data.add(stock['description']);
      data.add(stock['symbol']);
      stocklist.add(data);
    }
  }
  return stocklist;
}
