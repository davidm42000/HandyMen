import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/tradesman_edit_profile_page.dart';
import 'package:handy_men/screens/tradesman_profile_page.dart';
import 'package:handy_men/screens/view_tradesman_profile_page.dart';
import 'package:handy_men/templates/normal_user_jobs_done_list.dart';
import 'package:handy_men/templates/normal_user_ongoing_jobs_list.dart';
import 'package:handy_men/templates/normal_user_quotes_list.dart';
import 'package:handy_men/templates/tradesman_job_request_list.dart';
import 'package:handy_men/templates/tradesman_ongoing_jobs_list.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class NormalUserNotificationsPageList extends StatefulWidget {
  final User user;
  const NormalUserNotificationsPageList({required this.user, Key? key})
      : super(key: key);

  @override
  _NormalUserNotificationsPageListState createState() =>
      _NormalUserNotificationsPageListState();
}

class _NormalUserNotificationsPageListState
    extends State<NormalUserNotificationsPageList> {
  late User _currentUser;
  var num_job_requests;

  @override
  void initState() {
    getQuotesNum();
    getOngoingJobsNum();
    getOnJobsDoneNum();
    _currentUser = widget.user;
    super.initState();
  }

  CollectionReference normalUsers =
      FirebaseFirestore.instance.collection('normalUsers');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('normalUsers')
            .doc(widget.user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return (const Center(child: Text('Loading')));
          } else {
            var userDocument = snapshot.data;
            String name = userDocument!['name'].toString();
            print(name);

            return ListView(children: <Widget>[
              Card(
                margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                child: ListTile(
                  leading: Text(userDocument['quotes_num'].toString()),
                  title: Text('Quotes'),
                  trailing: FlatButton.icon(
                    icon: Icon(Icons.arrow_forward),
                    label: Text(''),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NormalUserQuotesList(
                                user: widget.user,
                              )));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  leading: Text(userDocument['ongoing_jobs_num'].toString()),
                  title: Text('Ongoing Jobs'),
                  trailing: FlatButton.icon(
                    icon: Icon(Icons.arrow_forward),
                    label: Text(''),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NormalUserOnGoingJobsList(
                                user: widget.user,
                              )));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  leading: Text(userDocument['jobs_done_num'].toString()),
                  title: Text('Jobs Done'),
                  trailing: FlatButton.icon(
                    icon: Icon(Icons.arrow_forward),
                    label: Text(''),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NormalUserJobsDoneList(
                                user: widget.user,
                              )));
                    },
                  ),
                ),
              ),
            ]);
          }
        });
  }

  Future<void> getQuotesNum() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await normalUsers.doc(widget.user.uid).collection('quotes').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    // final allData =
    //         querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();

    var length = allData.length;

    print('length of requests list is: $length');
    print(widget.user.uid);

    normalUsers.doc(widget.user.uid).update({
      'quotes_num': length,
    });
  }

  Future<void> getOngoingJobsNum() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await normalUsers.doc(widget.user.uid).collection('ongoing_jobs').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    // final allData =
    //         querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();

    var length = allData.length;

    normalUsers.doc(widget.user.uid).update({
      'ongoing_jobs_num': length,
    });
  }

  Future<void> getOnJobsDoneNum() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await normalUsers
        .doc(widget.user.uid)
        .collection('jobs_done_list')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    // final allData =
    //         querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();

    var length = allData.length;

    normalUsers.doc(widget.user.uid).update({
      'jobs_done_num': length,
    });
  }
}
