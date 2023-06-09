import 'dart:developer';
import 'dart:io';

import 'package:chat01/Screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Api/api.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgress(
      context,
    );
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log("user ${user.user}");
        log("user ${user.additionalUserInfo}");
        if ((await Apis.userExist())) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          await Apis.createUser().then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen())));
        }
      }
      // else {
      //   Navigator.pop(context);
      // }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      await InternetAddress.lookup("google.com");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("SignIn With Google $e");
      Dialogs.showSnackbar(
          context, "Some Thing rong check internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    /// initializing Mediaquery get for device size
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: const Icon(Icons.home),
        title: const Text("Welcome to we chat"),
      ),
      body: Stack(
        children: [
          /// app logo
          AnimatedPositioned(
            top: mq.height * .15,
            left: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset("images/icon.png"),
          ),

          /// google login button
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 223, 255, 187),
                  borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  _handleGoogleBtnClick();
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (_) => const HomeScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/google.png",
                      height: mq.height * .03,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RichText(
                        text: const TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                          TextSpan(text: "SignIn with "),
                          TextSpan(
                              text: "Google",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ]))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
