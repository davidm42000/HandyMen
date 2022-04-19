import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/tradesman_home_page.dart';
import 'package:handy_men/screens/tradesman_jobs_done_page.dart';
import 'package:handy_men/screens/tradesman_profile_page.dart';
import 'package:handy_men/screens/tradesman_review_new_job_page.dart';
import 'package:handy_men/screens/tradesmen_profile_page.dart';
import 'package:handy_men/services/upload_updated_job_done_image.dart';
import 'package:handy_men/services/upload_profile_image.dart';
import 'package:handy_men/services/validator.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/edit_profile_widget.dart';
import 'package:handy_men/templates/send_quote_form.dart';
import 'package:handy_men/templates/text_field_widget.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';

class TradesmanAcceptJobRequestPage extends StatefulWidget {
  final User user;
  final String docID;
  final String jobDescription;
  final String requesterName;
  final String requesterEmail;
  final String tradesmanName;
  const TradesmanAcceptJobRequestPage({
    Key? key,
    required this.user,
    required this.docID,
    required this.jobDescription,
    required this.requesterEmail,
    required this.requesterName,
    required this.tradesmanName,
  }) : super(key: key);

  @override
  _TradesmanAcceptJobRequestPageState createState() =>
      _TradesmanAcceptJobRequestPageState();
}

class _TradesmanAcceptJobRequestPageState
    extends State<TradesmanAcceptJobRequestPage> {
  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');

  //snackbar for showing errors and messages to users
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    Future _showSendQuotePanel() async {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                child: SendQuoteForm(
                  user: widget.user,
                  docID: widget.docID,
                  jobDescription: widget.jobDescription,
                  requesterName: widget.requesterName,
                  requesterEmail: widget.requesterEmail,
                  tradesmanName: widget.tradesmanName,
                ));
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Center(
          child: Text(
            'Accept Job Request',
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to Accept this Job Request?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
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
                  await _showSendQuotePanel();
                  setState(() {});
                  // tradesmen
                  //     .doc(widget.user.uid)
                  //     .collection('ongoing_jobs')
                  //     .doc(widget.docID)
                  //     .set({
                  //   'job_description': widget.jobDescription,
                  //   'requester_name': widget.requesterName,
                  //   'requester_email': widget.requesterEmail,
                  //   'id': widget.docID,
                  // }).whenComplete(() {
                  //   showSnackBar('Job Request Successfully accepted',
                  //       Duration(seconds: 1));
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //       builder: (context) => TradesmanHomePage(
                  //             user: widget.user,
                  //           )));
                  // });
                  // deleteJobRequest(context);
                },
              ),
            ],
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
