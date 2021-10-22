import 'package:flutter/material.dart';
import 'package:handy_men/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0.0,
        title: Text("Sign In to HandyMen"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          child: Text("Sign In Anon"),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null) {
              print("error signing in");
            } else {
              print("signed in");
              print(result);
            }
          },
        ),
      ),
    );
  }
}
