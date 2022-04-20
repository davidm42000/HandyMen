import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/tradesman_edit_profile_page.dart';
import 'package:handy_men/screens/tradesman_profile_page.dart';
import 'package:handy_men/screens/view_tradesman_profile_page.dart';
import 'package:handy_men/templates/tradesman_job_request_list.dart';
import 'package:handy_men/templates/tradesman_jobs_done_list.dart';
import 'package:handy_men/templates/tradesman_ongoing_jobs_list.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class TradesmanHomePageList extends StatefulWidget {
  final User user;
  const TradesmanHomePageList({required this.user, Key? key}) : super(key: key);

  @override
  _TradesmanHomePageListState createState() => _TradesmanHomePageListState();
}

class _TradesmanHomePageListState extends State<TradesmanHomePageList> {
  late User _currentUser;
  var num_job_requests;

  @override
  void initState() {
    getJobRequestNum();
    getOngoingJobsNum();
    getJobsDoneNum();
    _currentUser = widget.user;
    super.initState();
  }

  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tradesmen')
            .doc(widget.user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return (const Center(child: Text('Loading')));
          } else {
            var userDocument = snapshot.data;
            String name = userDocument!['name'].toString();

            return ListView(children: <Widget>[
              Column(
                children: [
                  Card(
                    margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                    child: ListTile(
                      leading: Text(userDocument['job_request_num'].toString()),
                      title: Text('Job Requests'),
                      trailing: FlatButton.icon(
                        icon: Icon(Icons.arrow_forward),
                        label: Text(''),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TradesmanJobRequestList(
                                    user: widget.user,
                                    tradesmanName: name,
                                  )));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: ListTile(
                      leading:
                          Text(userDocument['ongoing_jobs_num'].toString()),
                      title: Text('Ongoing Jobs'),
                      trailing: FlatButton.icon(
                        icon: Icon(Icons.arrow_forward),
                        label: Text(''),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TradesmanOnGoingJobsList(
                                    user: widget.user,
                                    tradesmanName: userDocument['name'],
                                  )));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: ListTile(
                      leading: Text(
                          userDocument['overall_jobs_done_num'].toString()),
                      title: Text('Jobs Done'),
                      trailing: FlatButton.icon(
                        icon: Icon(Icons.arrow_forward),
                        label: Text(''),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TradesmanJobsDoneList(
                                    user: widget.user,
                                    tradesmanName: userDocument['name'],
                                  )));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ]);
          }
        });
  }

  Future<void> getJobRequestNum() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await tradesmen.doc(widget.user.uid).collection('job_requests').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    // final allData =
    //         querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();

    var length = allData.length;

    print('length of requests list is: $length');

    tradesmen.doc(widget.user.uid).update({
      'job_request_num': length,
    });
  }

  Future<void> getOngoingJobsNum() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await tradesmen.doc(widget.user.uid).collection('ongoing_jobs').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    // final allData =
    //         querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();

    var length = allData.length;

    tradesmen.doc(widget.user.uid).update({
      'ongoing_jobs_num': length,
    });
  }

  Future<void> getJobsDoneNum() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await tradesmen.doc(widget.user.uid).collection('jobs_done_list').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    // final allData =
    //         querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();

    var length = allData.length;

    tradesmen.doc(widget.user.uid).update({
      'overall_jobs_done_num': length,
    });
  }
}
