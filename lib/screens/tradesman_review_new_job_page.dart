import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/tradesman_cancel_job_page.dart';
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

class TradesmanReviewNewJobPage extends StatefulWidget {
  final User user;
  final String docID;
  const TradesmanReviewNewJobPage(
      {Key? key, required this.user, required this.docID})
      : super(key: key);

  @override
  _TradesmanReviewNewJobPageState createState() =>
      _TradesmanReviewNewJobPageState();
}

class _TradesmanReviewNewJobPageState extends State<TradesmanReviewNewJobPage> {
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'Review & Finish New Job ',
        ),
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
              // String? name = userDocument['name'].toString();
              // String? email = userDocument['email'].toString();
              _descTextController = TextEditingController(text: desc);
              // _nameTextController = TextEditingController(text: name);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('Add Image'),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UploadNewJobDoneImage(
                                    user: widget.user,
                                    docID: widget.docID,
                                  )));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 42,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => TradesmanCancelJobPage(
                                        user: widget.user,
                                        docID: widget.docID,
                                      )));
                        },
                      ),
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Finish',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          tradesmen
                              .doc(widget.user.uid)
                              .collection('jobs_done')
                              .doc(widget.docID)
                              .update({
                            'description': _descTextController.text,
                          });

                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => TradesmanJobsDonePage(
                                        user: widget.user,
                                      )));
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
          }),
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
}
