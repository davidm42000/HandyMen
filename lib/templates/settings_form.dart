import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/normal_user_search_page.dart';
import 'package:handy_men/screens/normal_user_home_page_filtered.dart';
import 'package:handy_men/templates/tradesmen_list.dart';

class SettingsForm extends StatefulWidget {
  final String selectedDistance;
  final String selectedTrade;
  final User user;

  const SettingsForm(
      {Key? key,
      required this.user,
      required this.selectedDistance,
      required this.selectedTrade})
      : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
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

  double _distance = 20.0;

  late String _selectedDistance;
  late String _selectedTrade;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    _selectedDistance = widget.selectedDistance;
    _selectedTrade = widget.selectedTrade;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                String numStr = _selectedDistance.replaceAll(
                    new RegExp(r'[^0-9]'), ''); // '20'
                double d = double.parse(numStr);
                this._distance = double.parse(numStr);
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
              print('Selected Trade $_selectedTrade');
              print('Selected distance $_selectedDistance');
              print('Settings distnace $_distance');
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => NormalUserSearchPage(
                        user: _currentUser,
                        distance: _distance,
                        selectedDistance: _selectedDistance,
                        selectedTrade: _selectedTrade,
                      )));
            },
          ),
        ],
      ),
    );
  }
}
