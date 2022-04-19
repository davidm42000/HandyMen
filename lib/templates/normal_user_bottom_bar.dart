import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/normal_user_chat_page.dart';
import 'package:handy_men/screens/normal_user_notifications_page.dart';
import 'package:handy_men/screens/normal_user_search_page.dart';
import 'package:handy_men/screens/normal_user_profile_page.dart';

class NormalUserBottomBar extends StatefulWidget {
  final User user;
  const NormalUserBottomBar({required this.user, Key? key}) : super(key: key);

  @override
  _NormalUserBottomBarState createState() => _NormalUserBottomBarState();
}

class _NormalUserBottomBarState extends State<NormalUserBottomBar> {
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      NormalUserProfilePage(user: _currentUser),
                ),
              );
            },
            icon: Icon(Icons.person),
            label: Padding(padding: EdgeInsets.all(0)),
          ),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NormalUserNotificationsPage(
                    user: _currentUser,
                  ),
                ),
              );
            },
            icon: Icon(Icons.notifications),
            label: Padding(padding: EdgeInsets.all(0)),
          ),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NormalUserSearchPage(
                    user: _currentUser,
                    distance: 20.0,
                    selectedDistance: '20km',
                    selectedTrade: 'All',
                  ),
                ),
              );
            },
            icon: Icon(Icons.search),
            label: Padding(padding: EdgeInsets.all(0)),
          ),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NormalUserChatPage(user: _currentUser),
                ),
              );
            },
            icon: Icon(Icons.mail),
            label: Padding(padding: EdgeInsets.all(0)),
          ),
        ],
      ),
    );
  }
}
