import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/services/validator.dart';

class RequestJobPage extends StatefulWidget {
  final User user;
  final String id;
  const RequestJobPage({
    Key? key,
    required this.user,
    required this.id,
  }) : super(key: key);

  @override
  State<RequestJobPage> createState() => _RequestJobPageState();
}

class _RequestJobPageState extends State<RequestJobPage> {
  var _nameTextController = TextEditingController();
  var _emailTextController = TextEditingController();
  var _jobDescTextController = TextEditingController();
  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');

  //snackbar for showing errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'Job Request',
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
                'Description Of Job',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _jobDescTextController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          RaisedButton(
            color: Colors.pink[400],
            child: Text(
              'Send Job Request',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              tradesmen
                  .doc(widget.id)
                  .collection('job_requests')
                  .doc(widget.user.uid)
                  .set({
                'job_description': _jobDescTextController.text,
                'requester_name': widget.user.displayName,
                'requester_email': widget.user.email,
                'id': widget.user.uid,
              }).whenComplete(() {
                showSnackBar(
                    'Job Request Successfully Sent', Duration(seconds: 1));
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }
}
