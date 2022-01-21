import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/services/upload_image.dart';
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
  String url = 'https://picsum.photos/250?image=9';
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
          stream: FirebaseFirestore.instance
              .collection('tradesmen')
              .doc(widget.user.uid)
              .collection('images')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return (const Center(child: Text('No Image Uploaded')));
            } else {
              buildProfile();
              // String url = snapshot.data!.docs[0]['downloadURL'];
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                physics: BouncingScrollPhysics(),
                children: [
                  EditProfileWidget(
                    imagePath: url,
                    isEdit: true,
                    onClicked: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadImage(
                                user: widget.user,
                              )));
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Full Name',
                    text: 'Users Full Name',
                    onChanged: (name) {},
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Email',
                    text: 'Users Email',
                    onChanged: (email) {},
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'About',
                    text: 'Users About info',
                    maxLines: 5,
                    onChanged: (about) {},
                  ),
                ],
              );
            }
          }),
      bottomNavigationBar: TradesmenBottomBar(user: widget.user),
    );
  }

  Future buildProfile() async {
    FirebaseFirestore.instance
        .collection('tradesmen')
        .doc(widget.user.uid)
        .collection('images')
        .doc('profile_image')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        print(documentSnapshot['downloadURL'].toString());
        setState(() {
          url = documentSnapshot['downloadURL'].toString();
        });
      }
    });
  }
}
