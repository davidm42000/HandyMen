import 'package:flutter/material.dart';
import 'package:handy_men/screens/authenticate/authenticate.dart';
import 'package:handy_men/screens/home/home.dart';
import 'package:flutter/material.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return either home or authenticate widget.
    return Authenticate();
  }
}
