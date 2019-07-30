// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SOVINA',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: RandomWords());
  }
}

class RandomWordsState extends State<RandomWords> {
  final List<Price> _prices = <Price>[];
  final Set<Price> _savedPrices = Set<Price>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sovina prices'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildPricesList(),
    );
  }

  Widget _buildPricesList() {
    print("_buildPricesList");
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= _prices.length) {
            _prices.addAll(_buildRandomValues());
          }
          return _buildRow(_prices[index]);
        });
  }

  _buildRandomValues() {
    return generateWordPairs()
        .take(10)
        .map((wp) => new Price(wp, (Random().nextInt(10000).toString())));
  }

  Widget _buildRow(Price price) {
    final bool alreadySaved = _savedPrices.contains(price);
    return ListTile(
      title: Text(
        price.wp.asPascalCase,
        style: _biggerFont,
      ),
      subtitle: Text(price.price),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedPrices.remove(price);
          } else {
            _savedPrices.add(price);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          print('============ >>>>>' + _savedPrices.length.toString());
          final Iterable<ListTile> tiles = _savedPrices.map(
            (Price price) {
              return ListTile(
                title: Text(
                  price.wp.asPascalCase,
                  style: _biggerFont,
                ),
                subtitle: Text(price.price),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            // Add 6 lines from here...
            appBar: AppBar(
              title: Text('Saved Prices'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class Price {
  WordPair wp;
  String price;

  Price(WordPair wp, String price) {
    this.wp = wp;
    this.price = price;
  }
}
