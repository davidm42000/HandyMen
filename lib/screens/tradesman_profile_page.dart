import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/tradesman_edit_profile_page.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/edit_profile_widget.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';
import 'package:handy_men/templates/view_profile_widget.dart';

class TradesmanProfilePage extends StatefulWidget {
  final User user;
  const TradesmanProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _TradesmanProfilePageState createState() => _TradesmanProfilePageState();
}

class _TradesmanProfilePageState extends State<TradesmanProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          elevation: 0,
          title: Text(
            'Profile ',
          ),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.edit),
              label: Text('Edit'),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TradesmanEditProfilePage(
                          user: widget.user,
                        )));
              },
            ),
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tradesmen')
                .doc(widget.user.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return (const Center(child: Text('Loading')));
              } else {
                // String url = snapshot.data!.docs[0]['downloadURL'];
                var userDocument = snapshot.data;
                if (userDocument!['loggedIn'] == 'no') {
                  setStandardProfile();
                }
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    buildProfileImage(),
                    const SizedBox(
                      height: 24,
                    ),
                    Column(
                      children: [
                        Text(
                          userDocument['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          userDocument['email'],
                          style: TextStyle(color: Colors.grey, height: 3),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {},
                        child: Text('Contact'),
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            onPressed: () {},
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '4/5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Ranking',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          buildDivider(),
                          MaterialButton(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            onPressed: () {},
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '100',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Jobs Done',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userDocument['about'],
                            style: TextStyle(fontSize: 16, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
        bottomNavigationBar: TradesmenBottomBar(user: widget.user));
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
            return ViewProfileWidget(
              imagePath: url,
              onClicked: () {},
            );
          }
        });
  }

  // Widget buildProfileImage() {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(widget.user.uid)
  //       .collection('images')
  //       .doc('profile_image')
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       print('Document exists on the database');
  //       return StreamBuilder(
  //           stream: FirebaseFirestore.instance
  //               .collection('tradesmen')
  //               .doc(widget.user.uid)
  //               .collection('images')
  //               .doc('profile_image')
  //               .snapshots(),
  //           builder: (BuildContext context,
  //               AsyncSnapshot<DocumentSnapshot> snapshot) {
  //             if (!snapshot.hasData) {
  //               return (const Center(child: Text('No Image Uploaded')));
  //             } else {
  //               var userDocument = snapshot.data;
  //               // String url = snapshot.data!.docs[0]['downloadURL'];
  //               return ViewProfileWidget(
  //                 imagePath: userDocument!['downloadURL'],
  //                 onClicked: () {},
  //               );
  //             }
  //           });
  //     } else {
  //       return ViewProfileWidget(
  //         imagePath: 'https://picsum.photos/250?image=9',
  //         onClicked: () {},
  //       );
  //     }
  //   });
  //   return Padding(padding: EdgeInsets.symmetric(vertical: 2));
  // }

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  setStandardProfile() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    firebaseFirestore
        .collection('tradesmen')
        .doc(widget.user.uid)
        .collection('images')
        .doc('profile_image')
        .set({'downloadURL': 'https://picsum.photos/250?image=9'});

    firebaseFirestore.collection('tradesmen').doc(widget.user.uid).set({
      'name': '',
      'email': '',
      'about': '',
      'loggedIn': 'yes',
      'id': widget.user.uid,
    });
  }
}
