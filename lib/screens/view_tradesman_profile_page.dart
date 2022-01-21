import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/profile_widget.dart';
import 'package:handy_men/templates/view_profile_widget.dart';

class ViewTradesmanProfilePage extends StatefulWidget {
  final User user;
  final String name;
  final String email;
  const ViewTradesmanProfilePage({
    Key? key,
    required this.user,
    required this.name,
    required this.email,
  }) : super(key: key);

  @override
  _ViewTradesmanProfilePageState createState() =>
      _ViewTradesmanProfilePageState();
}

class _ViewTradesmanProfilePageState extends State<ViewTradesmanProfilePage> {
  @override
  Widget build(BuildContext context) {
    // final ref =
    //     FirebaseStorage.instance.ref().child('assets/images/electrician.jpg');
    // var url = ref.getDownloadURL();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          elevation: 0,
          title: Text(
            'Profile ',
          ),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            ViewProfileWidget(
              imagePath: 'https://picsum.photos/250?image=9',
              onClicked: () async {},
            ),
            const SizedBox(height: 24),
            buildName(),
            const SizedBox(height: 24),
            Center(child: buildContactButton()),
            const SizedBox(height: 24),
            buildNumbers(),
            const SizedBox(height: 48),
            buildAbout(),
          ],
        ),
        bottomNavigationBar: NormalUserBottomBar(user: widget.user));
  }

  Widget buildName() {
    return Column(
      children: [
        Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          widget.email,
          style: TextStyle(color: Colors.grey, height: 3),
        ),
      ],
    );
  }

  Widget buildContactButton() {
    return ElevatedButton(
      onPressed: () async {},
      child: Text('Contact'),
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
    );
  }

  Widget buildNumbers() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton('4/5', 'Ranking'),
          buildDivider(),
          buildButton('100', 'Jobs Done'),
        ],
      ),
    );
  }

  Widget buildButton(String value, String text) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 4),
      onPressed: () {},
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildAbout() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Users About Info',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }
}
