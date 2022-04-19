import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/normal_user_notifications_page.dart';
import 'package:handy_men/screens/normal_user_profile_page.dart';
import 'package:handy_men/screens/normal_user_search_page.dart';
import 'package:handy_men/screens/normal_user_home_page_filtered.dart';
import 'package:handy_men/screens/tradesman_home_page.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/tradesmen_list.dart';

class NormalUserRejectQuote extends StatefulWidget {
  final User user;
  final String docID;

  const NormalUserRejectQuote({
    Key? key,
    required this.user,
    required this.docID,
  }) : super(key: key);

  @override
  _NormalUserRejectQuoteState createState() => _NormalUserRejectQuoteState();
}

class _NormalUserRejectQuoteState extends State<NormalUserRejectQuote> {
  var _quoteTextController = TextEditingController();
  final _focusQuote = FocusNode();
  final _formkey = GlobalKey<FormState>();
  late User _currentUser;

  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');
  CollectionReference normalUsers =
      FirebaseFirestore.instance.collection('normalUsers');

  //snackbar for showing errors and messages to users
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.docID);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'Reject Quote',
        ),
        actions: <Widget>[],
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            Text(
              'Are you sure you want to reject this quote?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  color: Colors.green[400],
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    deleteJobQuote(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NormalUserBottomBar(user: widget.user),
    );
  }

  Future deleteJobQuote(BuildContext context) async {
    return await normalUsers
        .doc(widget.user.uid)
        .collection('quotes')
        .doc(widget.docID)
        .delete()
        .then((value) => print("Doc Deleted"))
        .whenComplete(
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => NormalUserNotificationsPage(
                      user: widget.user,
                    ))))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
