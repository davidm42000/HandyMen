import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:handy_men/screens/tradesman_contact_page.dart';
import 'package:handy_men/screens/view_tradesman_jobs_done_page.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/edit_profile_widget.dart';
import 'package:handy_men/templates/request_job_form_page.dart';
import 'package:handy_men/templates/view_profile_widget.dart';
import 'package:like_button/like_button.dart';

class ViewTradesmanProfilePage extends StatefulWidget {
  final User user;
  final String name;
  final String email;
  final String id;
  int likeCount;
  bool isLiked;
  ViewTradesmanProfilePage({
    Key? key,
    required this.user,
    required this.name,
    required this.email,
    required this.id,
    required this.likeCount,
    required this.isLiked,
  }) : super(key: key);

  @override
  _ViewTradesmanProfilePageState createState() =>
      _ViewTradesmanProfilePageState();
}

class _ViewTradesmanProfilePageState extends State<ViewTradesmanProfilePage> {
  final double size = 30;
  var _address = 'Not KNown';
  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');
  CollectionReference normalUsers =
      FirebaseFirestore.instance.collection('normalUsers');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          elevation: 0,
          title: Text(
            'Tradesman Profile ',
          ),
          actions: <Widget>[
            LikeButton(
              size: size,
              isLiked: widget.isLiked,
              likeCount: widget.likeCount,
              likeBuilder: (isLiked) {
                final color = isLiked ? Colors.red : Colors.white;

                return Icon(Icons.favorite, color: color, size: size);
              },
              countBuilder: (count, isLiked, text) {
                final color = isLiked ? Colors.black : Colors.white;

                return Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              onTap: (isLiked) async {
                widget.isLiked = !isLiked;
                widget.likeCount += widget.isLiked ? 1 : -1;

                tradesmen.doc(widget.id).update({
                  'like_count': widget.likeCount,
                });

                if (widget.isLiked == false) {
                  tradesmen.doc(widget.id).update({
                    'liked_by': FieldValue.arrayRemove([widget.user.uid]),
                  });

                  normalUsers.doc(widget.user.uid).update({
                    'favourites': FieldValue.arrayRemove([widget.id])
                  });
                }

                if (widget.isLiked == true) {
                  tradesmen.doc(widget.id).update({
                    'liked_by': FieldValue.arrayUnion([widget.user.uid]),
                  });
                  normalUsers.doc(widget.user.uid).update({
                    'favourites': FieldValue.arrayUnion([widget.id])
                  });
                }

                return !isLiked;
              },
            ),
          ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RequestJobPage(
                                    user: widget.user,
                                    id: widget.id,
                                  ),
                                ),
                              );
                            },
                            child: Text('Request Job'),
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 12),
                            ),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TradesmanContactPage(
                                        user: widget.user,
                                        id: widget.id,
                                        name: widget.name,
                                        email: widget.email,
                                      )));
                            },
                            child: Text('Contact'),
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                          ),
                        ),
                      ],
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
                                  userDocument['like_count'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Likes',
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
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      TradesmanViewJobsDonePage(
                                        user: widget.user,
                                        id: widget.id,
                                      )));
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  userDocument['jobs_done'].toString(),
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
                    const SizedBox(
                      height: 48,
                    ),
                    buildLocationBox(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _address,
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

  Widget buildLocationBox() {
    CollectionReference tradesmen =
        FirebaseFirestore.instance.collection('tradesmen');

    return FutureBuilder<DocumentSnapshot>(
      future: tradesmen.doc(widget.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          GeoPoint gp = data['location'];
          getLocation(gp).then((value) => {
                setState(() {
                  _address =
                      "${value.locality}, ${value.name}, ${value.postalCode}";
                })
              });
        }

        return Container();
      },
    );
  }

  Future<Placemark> getLocation(GeoPoint gp) async {
    double _lat = gp.latitude as double;
    double _long = gp.longitude as double;
    List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _long);
    Placemark place = placemarks[0];
    return place;
  }
}
