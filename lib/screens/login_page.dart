import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/normal_user_home_page.dart';
import 'package:handy_men/screens/normal_user_profile_page.dart';
import 'package:handy_men/screens/register_page.dart';
import 'package:handy_men/screens/tradesmen_profile_page.dart';
import 'package:handy_men/services/fire_auth.dart';
import 'package:handy_men/services/validator.dart';
import 'package:provider/provider.dart';
import 'package:handy_men/services/database.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  bool _isTrademan = false;

  String error = '';

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection('tradesmen')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Document exists on the database');
          if (_isTrademan != true) {
            setState(() {
              _isTrademan = true;
            });
          }
        }
      });

      if (_isTrademan == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => TrademenProfilePage(
                    user: user,
                  )),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => NormalUserHomePage(
                    user: user,
                  )),
        );
      }
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Authentication'),
          backgroundColor: Colors.orange,
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: ListView(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) => Validator.validateEmail(
                                email: value,
                              ),
                              decoration: InputDecoration(
                                hintText: "Email",
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText: true,
                              validator: (value) => Validator.validatePassword(
                                password: value,
                              ),
                              decoration: InputDecoration(
                                hintText: "Password",
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.0),
                            _isProcessing
                                ? CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            _focusEmail.unfocus();
                                            _focusPassword.unfocus();

                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isProcessing = true;
                                              });

                                              User? user = await FireAuth
                                                  .signInUsingEmailPassword(
                                                email:
                                                    _emailTextController.text,
                                                password:
                                                    _passwordTextController
                                                        .text,
                                              );

                                              setState(() {
                                                _isProcessing = false;
                                              });

                                              if (user != null) {
                                                FirebaseFirestore.instance
                                                    .collection('tradesmen')
                                                    .doc(user.uid)
                                                    .get()
                                                    .then((DocumentSnapshot
                                                        documentSnapshot) {
                                                  if (documentSnapshot.exists) {
                                                    print(
                                                        'Document exists on the database');
                                                    setState(() {
                                                      _isTrademan = true;
                                                    });
                                                  }
                                                });

                                                if (_isTrademan == true) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TrademenProfilePage(
                                                              user: user,
                                                            )),
                                                  );
                                                } else {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NormalUserHomePage(
                                                              user: user,
                                                            )),
                                                  );
                                                }
                                              } else {
                                                setState(() {
                                                  error =
                                                      'could not sign in with those credentials';
                                                });
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(),
                                          child: Text(
                                            'Sign In',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 24.0),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(),
                                          child: Text(
                                            'Register',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(height: 12.0),
                            Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ]),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
