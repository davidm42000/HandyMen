import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/profile_page.dart';
import 'package:handy_men/services/fire_auth.dart';
import 'package:handy_men/templates/bottom_bar.dart';
import 'package:handy_men/templates/tradesmen_list.dart';
import 'package:handy_men/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _tradesmanStream =
      FirebaseFirestore.instance.collection('tradesmen').snapshots();

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: Text('Bottom Sheet'),
            );
          });
    }

    // return MultiProvider(
    //   providers: [
    //     StreamProvider<List<Tradesman>>.value(
    //       initialData: [],
    //       value: DatabaseService().tradesmen,
    //     ),
    //   ],
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: Text('Home Page'),
    //       backgroundColor: Colors.orange,
    //       actions: <Widget>[
    //         FlatButton.icon(
    //           icon: Icon(Icons.settings),
    //           label: Text('settings'),
    //           onPressed: () => _showSettingsPanel(),
    //         ),
    //       ],
    //     ),
    //     body: TradesmenList(),
    //     bottomNavigationBar: BottomBar(user: _currentUser),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.settings),
            label: Text('settings'),
            onPressed: () => _showSettingsPanel(),
          ),
        ],
      ),
      body: TradesmenList(),
      bottomNavigationBar: BottomBar(user: _currentUser),
    );
  }
}
