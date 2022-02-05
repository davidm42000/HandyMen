import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/edit_profile_widget.dart';
import 'package:handy_men/templates/view_profile_widget.dart';

class ViewTradesmanProfilePage extends StatefulWidget {
  final User user;
  final String name;
  final String email;
  final String id;
  const ViewTradesmanProfilePage({
    Key? key,
    required this.user,
    required this.name,
    required this.email,
    required this.id,
  }) : super(key: key);

  @override
  _ViewTradesmanProfilePageState createState() =>
      _ViewTradesmanProfilePageState();
}

class _ViewTradesmanProfilePageState extends State<ViewTradesmanProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          elevation: 0,
          title: Text(
            'Tradesman Profile ',
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tradesmen')
                .doc(widget.id)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return (const Center(child: Text('Loading')));
              } else {
                // String url = snapshot.data!.docs[0]['downloadURL'];
                var userDocument = snapshot.data;
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
                          userDocument!['name'],
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
        bottomNavigationBar: NormalUserBottomBar(user: widget.user));
  }

  Widget buildProfileImage() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tradesmen')
            .doc(widget.id)
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

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );
}
