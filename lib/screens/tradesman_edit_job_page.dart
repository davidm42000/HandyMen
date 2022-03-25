import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/tradesman_delete_job_page.dart';
import 'package:handy_men/screens/tradesman_jobs_done_page.dart';
import 'package:handy_men/screens/tradesman_profile_page.dart';
import 'package:handy_men/screens/tradesmen_profile_page.dart';
import 'package:handy_men/services/upload_updated_job_done_image.dart';
import 'package:handy_men/services/upload_profile_image.dart';
import 'package:handy_men/services/validator.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/edit_profile_widget.dart';
import 'package:handy_men/templates/text_field_widget.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';

class TradesmanEditJobPage extends StatefulWidget {
  final User user;
  final String docID;
  final int jobsDoneAmount;
  const TradesmanEditJobPage({
    Key? key,
    required this.user,
    required this.docID,
    required this.jobsDoneAmount,
  }) : super(key: key);

  @override
  _TradesmanEditJobPageState createState() => _TradesmanEditJobPageState();
}

class _TradesmanEditJobPageState extends State<TradesmanEditJobPage> {
  var _nameTextController = TextEditingController();
  var _emailTextController = TextEditingController();
  var _descTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();

  final TextEditingController _controller = TextEditingController();

  String aboutInfo = 'Tradesman';
  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'Edit Job ',
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.delete),
            label: Text('Delete'),
            onPressed: () async {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => TradesmanDeleteJobPage(
                        jobsDoneAmount: widget.jobsDoneAmount,
                        user: widget.user,
                        docID: widget.docID,
                      )));
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tradesmen')
              .doc(widget.user.uid)
              .collection('jobs_done')
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
              String? desc = userDocument!['description'].toString();
              String? name = userDocument['name'].toString();
              // String? name = userDocument['name'].toString();
              // String? email = userDocument['email'].toString();
              _descTextController = TextEditingController(text: desc);
              _nameTextController = TextEditingController(text: name);
              // _emailTextController = TextEditingController(text: email);
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                physics: BouncingScrollPhysics(),
                children: [
                  // buildProfileImage(),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Job Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameTextController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descTextController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  buildJobsDoneEditImages(widget.docID),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      tradesmen
                          .doc(widget.user.uid)
                          .collection('jobs_done')
                          .doc(widget.docID)
                          .update({
                        'description': _descTextController.text,
                        'name': _nameTextController.text,
                      });
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              );
            }
          }),
      bottomNavigationBar: TradesmenBottomBar(user: widget.user),
    );
  }

  Widget buildJobsDoneEditImages(var id) {
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
        print(capacity);
        print(snapshot.data!.docs.length);

        return Center(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: capacity,
            itemBuilder: (context, index) {
              print(snapshot.data!.docs[index].id);
              var _imageID = snapshot.data!.docs[index].id;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 240,
                  ),
                  Center(
                    child: Stack(children: [
                      Material(
                          color: Colors.transparent,
                          child: Ink.image(
                            image: NetworkImage(
                              snapshot.data!.docs[index]['downloadURL'],
                            ),
                            width: 340,
                            height: 200,
                            child: InkWell(
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UploadJobDoneImage(
                                          user: widget.user,
                                          docID: widget.docID,
                                          imageID: _imageID,
                                        )));
                              },
                            ),
                          )),
                      Positioned(
                        bottom: 0,
                        right: 14,
                        child: buildEditIcon(),
                      ),
                    ]),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget buildEditIcon() {
    return buildCircle(
      all: 8,
      child: Icon(
        Icons.add_a_photo,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
        child: Container(
          child: child,
          padding: EdgeInsets.all(all),
          color: Colors.blueAccent,
        ),
      );

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
