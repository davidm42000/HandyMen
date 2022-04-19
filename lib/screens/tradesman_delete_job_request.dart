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

class TradesmanDeleteJobRequestPage extends StatefulWidget {
  final User user;
  final String docID;
  const TradesmanDeleteJobRequestPage({
    Key? key,
    required this.user,
    required this.docID,
  }) : super(key: key);

  @override
  _TradesmanDeleteJobRequestPageState createState() =>
      _TradesmanDeleteJobRequestPageState();
}

class _TradesmanDeleteJobRequestPageState
    extends State<TradesmanDeleteJobRequestPage> {
  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Center(
          child: Text(
            'Delete Job Request',
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
                'Are you sure you want to Delete this Job Request?',
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
                  deleteJobRequest(context);
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
