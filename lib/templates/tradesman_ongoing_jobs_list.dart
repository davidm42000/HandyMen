import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/tradesman_edit_profile_page.dart';
import 'package:handy_men/screens/tradesman_job_request_info.dart';
import 'package:handy_men/screens/tradesman_ongoing_job_info.dart';
import 'package:handy_men/screens/tradesman_profile_page.dart';
import 'package:handy_men/screens/view_tradesman_profile_page.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class TradesmanOnGoingJobsList extends StatefulWidget {
  final User user;
  final String tradesmanName;
  const TradesmanOnGoingJobsList({
    required this.user,
    required this.tradesmanName,
    Key? key,
  }) : super(key: key);

  @override
  _TradesmanOnGoingJobsListState createState() =>
      _TradesmanOnGoingJobsListState();
}

class _TradesmanOnGoingJobsListState extends State<TradesmanOnGoingJobsList> {
  @override
  void initState() {
    super.initState();
  }

  late Stream<QuerySnapshot> _ongoingJobStream = FirebaseFirestore.instance
      .collection('tradesmen')
      .doc(widget.user.uid)
      .collection('ongoing_jobs')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Jobs'),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.settings),
            label: Text(''),
            onPressed: () async {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ongoingJobStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              String _id = data['id'];
              print(_id);
              return Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Card(
                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  child: ListTile(
                    title: Text(data['job_description'.toString()]),
                    trailing: FlatButton.icon(
                      icon: Icon(Icons.arrow_forward),
                      label: Text(''),
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TradesmanOnGoingJobInfoPage(
                                  user: widget.user,
                                  docID: _id,
                                  tradesmanName: widget.tradesmanName,
                                )));
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: TradesmenBottomBar(user: widget.user),
    );
  }
}
