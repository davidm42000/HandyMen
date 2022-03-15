import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class TradesmanDeleteJobPage extends StatefulWidget {
  final User user;
  final String docID;
  final int jobsDoneAmount;
  const TradesmanDeleteJobPage({
    Key? key,
    required this.user,
    required this.docID,
    required this.jobsDoneAmount,
  }) : super(key: key);

  @override
  _TradesmanDeleteJobPageState createState() => _TradesmanDeleteJobPageState();
}

class _TradesmanDeleteJobPageState extends State<TradesmanDeleteJobPage> {
  var _length;
  var _nameTextController = TextEditingController();
  var _emailTextController = TextEditingController();
  var _descTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();

  final TextEditingController _controller = TextEditingController();

  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Center(
          child: Text(
            'Delete Job',
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
                'Are you sure you want to Delete this Job?',
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
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  var jobs_done_amount = widget.jobsDoneAmount - 1;
                  tradesmen.doc(widget.user.uid).update({
                    'jobs_done': jobs_done_amount,
                  });
                  deleteDoc(context);
                },
              ),
              // RaisedButton(
              //   color: Colors.pink[400],
              //   child: Text(
              //     'Next',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onPressed: () async {
              //     tradesmen
              //         .doc(widget.user.uid)
              //         .collection('jobs_done')
              //         .doc(_id)
              //         .set({
              //       'description': _descTextController.text,
              //       'id': _id,
              //     });
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => TradesmanReviewNewJobPage(
              //               user: widget.user,
              //               docID: _id,
              //             )));
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Future deleteDoc(BuildContext context) async {
    return await tradesmen
        .doc(widget.user.uid)
        .collection('jobs_done')
        .doc(widget.docID)
        .delete()
        .then((value) => print("Doc Deleted"))
        .whenComplete(
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => TradesmanJobsDonePage(
                      user: widget.user,
                      jobsDoneAmount: widget.jobsDoneAmount,
                    ))))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
