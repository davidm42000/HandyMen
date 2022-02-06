import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:handy_men/screens/tradesman_edit_profile_page.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/edit_profile_widget.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';
import 'package:handy_men/templates/view_profile_widget.dart';
import 'package:location/location.dart' as loc;

class TradesmanJobsDonePage extends StatefulWidget {
  final User user;
  final String id;
  const TradesmanJobsDonePage({
    Key? key,
    required this.user,
    required this.id,
  }) : super(key: key);

  @override
  _TradesmanJobsDonePageState createState() => _TradesmanJobsDonePageState();
}

class _TradesmanJobsDonePageState extends State<TradesmanJobsDonePage> {
  @override
  void initState() {
    // enableService();
    super.initState();
  }

  late Stream<QuerySnapshot> _jobsDoneStream = FirebaseFirestore.instance
      .collection('tradesmen')
      .doc(widget.id)
      .collection('jobs_done')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          elevation: 0,
          title: Text(
            'Jobs Done ',
          ),
          actions: <Widget>[],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _jobsDoneStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                var _jobDescription = data['description'];
                var _id = data['id'];
                print(_jobDescription);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _jobDescription,
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                      buildJobsDoneImages(_id),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        bottomNavigationBar: TradesmenBottomBar(user: widget.user));
  }

  Widget buildJobsDoneImages(var id) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tradesmen')
            .doc(widget.id)
            .collection('jobs_done')
            .doc(id)
            .collection('images')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return (const Center(child: Text('No Image Uploaded')));
          } else {
            int capacity = snapshot.data!.docs.length;
            String url = snapshot.data!.docs[0]['downloadURL'];
            print(capacity);
            print(url);
            // print(url);
            // print(snapshot.data!.docs[0].get('downloadURL'));
            return Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: NetworkImage(snapshot.data!.docs[0]['downloadURL']),
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                  child: InkWell(),
                ));
          }
        });
  }
}
