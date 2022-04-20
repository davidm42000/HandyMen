import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/tradesman_accept_job_request.dart';
import 'package:handy_men/screens/tradesman_cancel_job_page.dart';
import 'package:handy_men/screens/tradesman_confirm_job_done_page.dart';
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

class TradesmanJobDoneInfoPage extends StatefulWidget {
  final User user;
  final String docID;
  final String tradesmanName;
  const TradesmanJobDoneInfoPage({
    Key? key,
    required this.user,
    required this.docID,
    required this.tradesmanName,
  }) : super(key: key);

  @override
  _TradesmanJobDoneInfoPageState createState() =>
      _TradesmanJobDoneInfoPageState();
}

class _TradesmanJobDoneInfoPageState extends State<TradesmanJobDoneInfoPage> {
  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'Job Done Info',
        ),
        actions: <Widget>[],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tradesmen')
              .doc(widget.user.uid)
              .collection('jobs_done_list')
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
                        userDocument!['contact_name'],
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
                        userDocument['contact_email'],
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
                      Text(
                        'Price',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "€${userDocument['price']}",
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: 28),
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
