import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/templates/favourites_settings_form.dart';
import 'package:handy_men/templates/normal_user_favourites_list.dart';
import 'package:handy_men/screens/normal_user_profile_page.dart';
import 'package:handy_men/services/fire_auth.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/settings_form.dart';
import 'package:handy_men/templates/tradesmen_list.dart';
import 'package:handy_men/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NormalUserFavouritesPage extends StatefulWidget {
  final String selectedDistance;
  final String selectedTrade;
  final double distance;
  final User user;

  const NormalUserFavouritesPage({
    required this.user,
    required this.selectedDistance,
    required this.selectedTrade,
    required this.distance,
    Key? key,
  }) : super(key: key);

  @override
  _NormalUserFavouritesPageState createState() =>
      _NormalUserFavouritesPageState();
}

class _NormalUserFavouritesPageState extends State<NormalUserFavouritesPage> {
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
              child: FavouritesSettingsForm(
                user: _currentUser,
                selectedDistance: _selectedDistance,
                selectedTrade: _selectedTrade,
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites Page'),
        backgroundColor: Colors.orange,
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
      body: FavouriteTradesmenList(
        distance: _distance,
        tradeType: _selectedTrade,
        user: _currentUser,
      ),
      bottomNavigationBar: NormalUserBottomBar(user: _currentUser),
    );
  }
}
