import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:handy_men/screens/tradesman_edit_job_page.dart';
import 'package:handy_men/screens/tradesman_edit_profile_page.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/edit_profile_widget.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';
import 'package:handy_men/templates/view_profile_widget.dart';
import 'package:location/location.dart' as loc;

class TradesmanJobsDonePage extends StatefulWidget {
  final User user;
  const TradesmanJobsDonePage({
    Key? key,
    required this.user,
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
      .doc(widget.user.uid)
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
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    Row(
                      children: [
                        Text(
                          'Job Description',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 15),
                        FlatButton.icon(
                          icon: Icon(
                            Icons.edit,
                            size: 20,
                          ),
                          label: Text(
                            'Edit Job',
                            style: TextStyle(fontSize: 13),
                          ),
                          color: Colors.orange[400],
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TradesmanEditJobPage(
                                      user: widget.user,
                                      docID: _id,
                                    )));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _jobDescription,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 30),
                    buildJobsDoneImages(_id),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget buildJobsDoneImages(var id) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tradesmen')
          .doc(widget.user.uid)
          .collection('jobs_done')
          .doc(id)
          .collection('images')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return (const Center(child: Text('No Image Uploaded')));
        }
        int capacity = snapshot.data!.docs.length;
        String url = snapshot.data!.docs[0]['downloadURL'];
        print(capacity);
        print(url);
        print(snapshot.data!.docs.length);

        return Center(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: capacity,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 240,
                  ),
                  Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: NetworkImage(
                            snapshot.data!.docs[index]['downloadURL']),
                        width: 300,
                        height: 200,
                        child: InkWell(),
                      )),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
