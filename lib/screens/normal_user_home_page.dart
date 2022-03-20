import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/normal_user_profile_page.dart';
import 'package:handy_men/services/fire_auth.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/settings_form.dart';
import 'package:handy_men/templates/tradesmen_list.dart';
import 'package:handy_men/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NormalUserHomePage extends StatefulWidget {
  final String selectedDistance;
  final String selectedTrade;
  final double distance;
  final User user;

  const NormalUserHomePage({
    required this.user,
    required this.selectedDistance,
    required this.selectedTrade,
    required this.distance,
    Key? key,
  }) : super(key: key);

  @override
  _NormalUserHomePageState createState() => _NormalUserHomePageState();
}

class _NormalUserHomePageState extends State<NormalUserHomePage> {
  final Stream<QuerySnapshot> _tradesmanStream =
      FirebaseFirestore.instance.collection('tradesmen').snapshots();

  late String _selectedDistance;

  late String _selectedTrade;

  late double _distance;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    _distance = widget.distance;
    _selectedDistance = widget.selectedDistance;
    _selectedTrade = widget.selectedTrade;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future _showSettingsPanel() async {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(
                user: _currentUser,
                selectedDistance: _selectedDistance,
                selectedTrade: _selectedTrade,
              ),
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
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.settings),
            label: Text('Filter'),
            onPressed: () async {
              await _showSettingsPanel();
              setState(() {});
            },
          ),
        ],
      ),
      body: TradesmenList(
        distance: _distance,
        tradeType: _selectedTrade,
        user: _currentUser,
      ),
      bottomNavigationBar: NormalUserBottomBar(user: _currentUser),
    );
  }
}
