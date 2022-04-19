import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/normal_user_notifications_list.dart';
import 'package:handy_men/templates/tradesman_home_page_list.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';

class NormalUserNotificationsPage extends StatefulWidget {
  final User user;
  const NormalUserNotificationsPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<NormalUserNotificationsPage> createState() =>
      _NormalUserNotificationsPageState();
}

class _NormalUserNotificationsPageState
    extends State<NormalUserNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
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
      body: NormalUserNotificationsPageList(user: widget.user),
      bottomNavigationBar: NormalUserBottomBar(user: widget.user),
    );
  }
}
