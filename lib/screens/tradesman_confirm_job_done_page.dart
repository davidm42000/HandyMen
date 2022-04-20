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
import 'package:handy_men/templates/text_field_widget.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';

class TradesmanConfirmJobDonePage extends StatefulWidget {
  final User user;
  final String docID;
  final String jobDescription;
  final String contactName;
  final String contactEmail;
  final String price;
  final String tradesmanName;
  const TradesmanConfirmJobDonePage({
    Key? key,
    required this.user,
    required this.docID,
    required this.jobDescription,
    required this.contactName,
    required this.contactEmail,
    required this.price,
    required this.tradesmanName,
  }) : super(key: key);

  @override
  _TradesmanConfirmJobDonePageState createState() =>
      _TradesmanConfirmJobDonePageState();
}

class _TradesmanConfirmJobDonePageState
    extends State<TradesmanConfirmJobDonePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Center(
          child: Text(
            'Job Done',
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
                'Are you sure that this Job is done?',
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
                  tradesmen
                      .doc(widget.user.uid)
                      .collection('jobs_done_list')
                      .doc(widget.docID)
                      .set({
                    'job_description': widget.jobDescription,
                    'contact_name': widget.contactName,
                    'contact_email': widget.contactEmail,
                    'id': widget.docID,
                    'price': widget.price,
                  });
                  normalUsers
                      .doc(widget.docID)
                      .collection('jobs_done_list')
                      .doc(widget.user.uid)
                      .set({
                    'job_description': widget.jobDescription,
                    'tradesman_name': widget.tradesmanName,
                    'tradesman_email': widget.user.email,
                    'id': widget.user.uid,
                    'price': widget.price,
                  }).whenComplete(() {
                    showSnackBar('Job Successfully Done', Duration(seconds: 1));
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => TradesmanHomePage(
                              user: widget.user,
                            )));
                  });
                  deleteJobFromOngoingJobsListTradesman(context);
                  deleteJobFromOngoingJobsListNormalUser(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future deleteJobFromOngoingJobsListTradesman(BuildContext context) async {
    return await tradesmen
        .doc(widget.user.uid)
        .collection('ongoing_jobs')
        .doc(widget.docID)
        .delete()
        .then((value) => print("Doc Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future deleteJobFromOngoingJobsListNormalUser(BuildContext context) async {
    return await normalUsers
        .doc(widget.docID)
        .collection('ongoing_jobs')
        .doc(widget.user.uid)
        .delete()
        .then((value) => print("Doc Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
