import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';

class NormalUserChatPage extends StatefulWidget {
  final User user;
  const NormalUserChatPage({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  State<NormalUserChatPage> createState() => _NormalUserChatPageState();
}

class _NormalUserChatPageState extends State<NormalUserChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Conversations",
          style: TextStyle(fontSize: 28),
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.add,
              color: Colors.pink,
              size: 20,
            ),
            label: Text('Add New'),
            onPressed: () async {},
          ),
        ],
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SearchWidget(),
          ],
        ),
      ),
      bottomNavigationBar: NormalUserBottomBar(user: widget.user),
    );
  }

  Widget SearchWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 20,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade100)),
        ),
      ),
    );
  }
}
