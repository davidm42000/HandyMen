import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/normal_user_home_page.dart';
import 'package:handy_men/screens/normal_user_profile_page.dart';
import 'package:handy_men/screens/tradesmen_home_page.dart';
import 'package:handy_men/screens/tradesmen_profile_page.dart';

class TradesmenBottomBar extends StatefulWidget {
  final User user;
  const TradesmenBottomBar({required this.user, Key? key}) : super(key: key);

  @override
  _TradesmenBottomBarState createState() => _TradesmenBottomBarState();
}

class _TradesmenBottomBarState extends State<TradesmenBottomBar> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton.icon(
            onPressed: () {
              setState(() {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        TrademenProfilePage(user: _currentUser),
                  ),
                );
              });
            },
            icon: Icon(Icons.person),
            label: Padding(padding: EdgeInsets.all(0)),
          ),
          FlatButton.icon(
            onPressed: () {
              setState(() {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TradesmanHomePage(user: _currentUser),
                  ),
                );
              });
            },
            icon: Icon(Icons.home),
            label: Padding(padding: EdgeInsets.all(0)),
          ),
          FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.mail),
            label: Padding(padding: EdgeInsets.all(0)),
          ),
        ],
      ),
    );
  }
}
