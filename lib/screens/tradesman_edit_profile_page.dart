import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/profile_widget.dart';
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: 'https://picsum.photos/250?image=9',
            isEdit: true,
            onClicked: () {},
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
      ),
      bottomNavigationBar: TradesmenBottomBar(user: widget.user),
    );
  }
}
