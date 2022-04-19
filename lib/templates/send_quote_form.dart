import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/normal_user_search_page.dart';
import 'package:handy_men/screens/normal_user_home_page_filtered.dart';
import 'package:handy_men/screens/tradesman_home_page.dart';
import 'package:handy_men/templates/tradesmen_list.dart';

class SendQuoteForm extends StatefulWidget {
  final User user;
  final String docID;
  final String jobDescription;
  final String requesterName;
  final String requesterEmail;
  final String tradesmanName;

  const SendQuoteForm({
    Key? key,
    required this.user,
    required this.docID,
    required this.jobDescription,
    required this.requesterEmail,
    required this.requesterName,
    required this.tradesmanName,
  }) : super(key: key);

  @override
  _SendQuoteFormState createState() => _SendQuoteFormState();
}

class _SendQuoteFormState extends State<SendQuoteForm> {
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
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          Text(
            'Send Quote',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            focusNode: _focusQuote,
            controller: _quoteTextController,
            decoration: new InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: "Enter your quote in euros"),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 30.0,
          ),
          RaisedButton(
            color: Colors.green[400],
            child: Text(
              'Send',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              print(widget.docID);
              normalUsers
                  .doc(widget.docID)
                  .collection('quotes')
                  .doc(widget.user.uid)
                  .set({
                'job_description': widget.jobDescription,
                'requester_email': widget.user.email,
                'id': widget.user.uid,
                'quote': _quoteTextController.text,
                'tradesman_name': widget.tradesmanName,
              }).whenComplete(() {
                showSnackBar(
                    'Job Request Successfully accepted', Duration(seconds: 1));
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => TradesmanHomePage(
                          user: widget.user,
                        )));
              });
              deleteJobRequest(context);
            },
          ),
        ],
      ),
    );
  }

  Future deleteJobRequest(BuildContext context) async {
    return await tradesmen
        .doc(widget.user.uid)
        .collection('job_requests')
        .doc(widget.docID)
        .delete()
        .then((value) => print("Doc Deleted"))
        .whenComplete(
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => TradesmanHomePage(
                      user: widget.user,
                    ))))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
