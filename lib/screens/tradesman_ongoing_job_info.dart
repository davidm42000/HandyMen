import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/tradesman_accept_job_request.dart';
import 'package:handy_men/screens/tradesman_cancel_job_page.dart';
import 'package:handy_men/screens/tradesman_delete_job_request.dart';
import 'package:handy_men/screens/tradesman_home_page.dart';
import 'package:handy_men/screens/tradesman_jobs_done_page.dart';
import 'package:handy_men/screens/tradesman_profile_page.dart';
import 'package:handy_men/screens/tradesmen_profile_page.dart';
import 'package:handy_men/services/upload_new_job_done_image.dart';
import 'package:handy_men/services/upload_updated_job_done_image.dart';
import 'package:handy_men/services/upload_profile_image.dart';
import 'package:handy_men/services/validator.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/edit_profile_widget.dart';
import 'package:handy_men/templates/text_field_widget.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';

class TradesmanOnGoingJobInfoPage extends StatefulWidget {
  final User user;
  final String docID;
  const TradesmanOnGoingJobInfoPage({
    Key? key,
    required this.user,
    required this.docID,
  }) : super(key: key);

  @override
  _TradesmanOnGoingJobInfoPageState createState() =>
      _TradesmanOnGoingJobInfoPageState();
}

class _TradesmanOnGoingJobInfoPageState
    extends State<TradesmanOnGoingJobInfoPage> {
  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'Ongoing Job Info',
        ),
        actions: <Widget>[],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tradesmen')
              .doc(widget.user.uid)
              .collection('ongoing_jobs')
              .doc(widget.docID)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return (const Center(child: Text('Loading')));
            } else if (snapshot.hasError) {
              return Text('Something went wrong');
            } else {
              var userDocument = snapshot.data;
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                physics: BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userDocument!['requester_name'],
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userDocument['requester_email'],
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userDocument['job_description'],
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        color: Colors.green[400],
                        child: Text(
                          'Job Done',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          // Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             TradesmanAcceptJobRequestPage(
                          //               user: widget.user,
                          //               docID: widget.docID,
                          //               jobDescription:
                          //                   userDocument['job_description'],
                          //               requesterName:
                          //                   userDocument['requester_name'],
                          //               requesterEmail:
                          //                   userDocument['requester_email'],
                          //             )));
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
          }),
      bottomNavigationBar: TradesmenBottomBar(user: widget.user),
    );
  }
}
