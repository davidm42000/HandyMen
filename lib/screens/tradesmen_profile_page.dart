import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handy_men/screens/login_page.dart';
import 'package:handy_men/services/fire_auth.dart';
import 'package:handy_men/templates/normal_user_bottom_bar.dart';
import 'package:handy_men/templates/tradesmen_bottom_bar.dart';

class TrademenProfilePage extends StatefulWidget {
  final User user;

  const TrademenProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _TrademenProfilePageState createState() => _TrademenProfilePageState();
}

class _TrademenProfilePageState extends State<TrademenProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tradesmen Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAME: ${widget.user.displayName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Text(
              'EMAIL: ${widget.user.email}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            widget.user.emailVerified
                ? Text(
                    'Email verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.green),
                  )
                : Text(
                    'Email not verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.red),
                  ),
            SizedBox(height: 16.0),
            _isSendingVerification
                ? CircularProgressIndicator()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            this._isSendingVerification = true;
                          });
                          await widget.user.sendEmailVerification();
                          setState(() {
                            this._isSendingVerification = false;
                          });
                        },
                        child: Text('Verify email'),
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () async {
                          User? user = await FireAuth.refreshUser(widget.user);
                        },
                      ),
                    ],
                  ),
            SizedBox(height: 16.0),
            _isSigningOut
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        this._isSigningOut = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        setState(() {
                          this._isSigningOut = false;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        });
                      }
                    },
                    child: Text('Sign out'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: TradesmenBottomBar(user: widget.user),
    );
  }
}
