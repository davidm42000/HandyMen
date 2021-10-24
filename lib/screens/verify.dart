import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;

  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser;
    if (user == null) {
      throw Exception("cant send email, user equals null");
    }
    else {
      // user.sendEmailVerification();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
