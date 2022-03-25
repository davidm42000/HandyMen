import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/templates/tradesman_home_page_list.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';

class TradesmanHomePage extends StatefulWidget {
  final User user;
  const TradesmanHomePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<TradesmanHomePage> createState() => _TradesmanHomePageState();
}

class _TradesmanHomePageState extends State<TradesmanHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.settings),
            label: Text(''),
            onPressed: () async {},
          ),
        ],
      ),
      body: TradesmanHomePageList(user: widget.user),
      bottomNavigationBar: TradesmenBottomBar(user: widget.user),
    );
  }
}
