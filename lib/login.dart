import 'package:evented/constants.dart';
import 'package:flutter/material.dart';
import 'package:evented/database.dart';

import 'main.dart';

class GoogleLogin extends StatefulWidget {
  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/evented_logo_white_without_bg.png',
          height: 1.0,
        ),
        centerTitle: true,
        title: Text(
          "evented Login",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        color: kPrimaryBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/evented_logo_white_without_bg.png',
              height: 180.0,
              color: kPrimaryColor,
            ),
            OutlineButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
              borderSide: BorderSide(color: kPrimaryColor, width: 3.0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/google_logo_without_bg.png',
                      height: 32.0,
                    ),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                signInWithGoogle().whenComplete(() {
                  print("Hello");

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return Evented();
                    },
                  ));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
