import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/normal_user_job_done_info_page.dart';
import 'package:handy_men/screens/normal_user_ongoing_job_info.dart';
import 'package:handy_men/screens/tradesman_edit_profile_page.dart';
import 'package:handy_men/screens/tradesman_job_request_info.dart';
import 'package:handy_men/screens/tradesman_ongoing_job_info.dart';
import 'package:handy_men/screens/tradesman_profile_page.dart';
import 'package:handy_men/screens/view_tradesman_profile_page.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class NormalUserJobsDoneList extends StatefulWidget {
  final User user;
  const NormalUserJobsDoneList({required this.user, Key? key})
      : super(key: key);

  @override
  _NormalUserJobsDoneListState createState() => _NormalUserJobsDoneListState();
}

class _NormalUserJobsDoneListState extends State<NormalUserJobsDoneList> {
  @override
  void initState() {
    super.initState();
  }

  late Stream<QuerySnapshot> _ongoingJobStream = FirebaseFirestore.instance
      .collection('normalUsers')
      .doc(widget.user.uid)
      .collection('jobs_done_list')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs Done'),
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
              var _id = data['id'];
              print("id: $_id");
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
                            builder: (context) => NormalUserJobsDoneInfoPage(
                                  user: widget.user,
                                  docID: _id,
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
      bottomNavigationBar: NormalUserBottomBar(user: widget.user),
    );
  }
}
