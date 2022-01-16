import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/normal_user_profile_page.dart';
import 'package:handy_men/services/fire_auth.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/tradesmen_list.dart';
import 'package:handy_men/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NormalUserHomePage extends StatefulWidget {
  final User user;

  const NormalUserHomePage({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _NormalUserHomePageState createState() => _NormalUserHomePageState();
}

class _NormalUserHomePageState extends State<NormalUserHomePage> {
  final Stream<QuerySnapshot> _tradesmanStream =
      FirebaseFirestore.instance.collection('tradesmen').snapshots();

  final _formkey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> get tradesDropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("All"), value: "All"),
      DropdownMenuItem(child: Text("Electrician"), value: "Electrician"),
      DropdownMenuItem(child: Text("Plumber"), value: "Plumber"),
      DropdownMenuItem(child: Text("Mechanic"), value: "Mechanic"),
      DropdownMenuItem(child: Text("Carpenter"), value: "Carpenter"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get distancesDropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("5km"), value: "5km"),
      DropdownMenuItem(child: Text("10km"), value: "10km"),
      DropdownMenuItem(child: Text("20km"), value: "20km"),
      DropdownMenuItem(child: Text("40km"), value: "40km"),
      DropdownMenuItem(child: Text("80km"), value: "80km"),
    ];
    return menuItems;
  }

  String? _selectedTrade = "All";
  String _selectedDistance = "20km";

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
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Filter Trades And Distance',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    DropdownButtonFormField(
                      value: _selectedTrade,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTrade = newValue!;
                        });
                      },
                      items: tradesDropdownItems,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    DropdownButtonFormField(
                      value: _selectedDistance,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDistance = newValue!;
                        });
                      },
                      items: distancesDropdownItems,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        print(_selectedTrade);
                        print(_selectedDistance);
                      },
                    ),
                  ],
                ),
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
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.settings),
            label: Text('settings'),
            onPressed: () => _showSettingsPanel(),
          ),
        ],
      ),
      body: TradesmenList(
        distance: 12.00,
      ),
      bottomNavigationBar: NormalUserBottomBar(user: _currentUser),
    );
  }
}
