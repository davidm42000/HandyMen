import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/tradesman_profile_page.dart';
import 'package:handy_men/screens/tradesmen_profile_page.dart';
import 'package:handy_men/services/upload_profile_image.dart';
import 'package:handy_men/services/validator.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/edit_profile_widget.dart';
import 'package:handy_men/templates/text_field_widget.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';

class TradesmanEditProfilePage extends StatefulWidget {
  final User user;
  const TradesmanEditProfilePage({Key? key, required this.user})
      : super(key: key);

  @override
  _TradesmanEditProfilePageState createState() =>
      _TradesmanEditProfilePageState();
}

class _TradesmanEditProfilePageState extends State<TradesmanEditProfilePage> {
  var _nameTextController = TextEditingController();
  var _emailTextController = TextEditingController();
  var _aboutTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();

  final TextEditingController _controller = TextEditingController();

  String aboutInfo = 'Tradesman';
  // String url = 'https://picsum.photos/250?image=9';
  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'Edit Profile ',
        ),
      ),
      body: StreamBuilder(
          stream:
              // FirebaseFirestore.instance
              //     .collection('tradesmen')
              //     .doc(widget.user.uid)
              //     .collection('images')
              //     .snapshots(),
              FirebaseFirestore.instance
                  .collection('tradesmen')
                  .doc(widget.user.uid)
                  .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return (const Center(child: Text('Loading')));
            } else if (snapshot.hasError) {
              return Text('Something went wrong');
            } else {
              // String url = snapshot.data!.docs[0]['downloadURL'];
              var userDocument = snapshot.data;
              String? about = userDocument!['about'].toString();
              String? name = userDocument['name'].toString();
              String? email = userDocument['email'].toString();
              _aboutTextController = TextEditingController(text: about);
              _nameTextController = TextEditingController(text: name);
              _emailTextController = TextEditingController(text: email);
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                physics: BouncingScrollPhysics(),
                children: [
                  buildProfileImage(),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameTextController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        controller: _emailTextController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _aboutTextController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      tradesmen.doc(widget.user.uid).update({
                        'name': _nameTextController.text,
                        'about': _aboutTextController.text,
                        'email': _emailTextController.text,
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

  Widget buildProfileImage() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tradesmen')
            .doc(widget.user.uid)
            .collection('images')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return (const Center(child: Text('No Image Uploaded')));
          } else {
            String url = snapshot.data!.docs[0]['downloadURL'];
            return EditProfileWidget(
              imagePath: url,
              isEdit: true,
              onClicked: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UploadProfileImage(
                          user: widget.user,
                        )));
              },
            );
          }
        });
  }
}
