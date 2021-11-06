import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/tradesmen_list.dart';
import 'package:handy_men/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Tradesman>>.value(
      initialData: [],
      value: DatabaseService().tradesmen,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          backgroundColor: Colors.orange,
        ),
        body: TradesmenList(),
      ),
    );
  }
}
