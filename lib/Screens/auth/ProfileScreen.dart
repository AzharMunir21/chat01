import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat01/Screens/auth/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../Api/api.dart';
import '../../Model/ChatUser.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  final CharUser? user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Focus.of(context).unfocus(),
        child: Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                await Apis.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) async {
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  });
                });
                // await GoogleSignIn().signOut();
              },
              icon: const Icon(Icons.login),
              label: const Text("Logout"),
            ),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              title: const Text("Profile Screen"),
            ),
            body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: mq.width * .05),
                        child: Column(
                          children: [
                            /// for adding space
                            SizedBox(
                              width: mq.width,
                              height: mq.height * .03,
                            ),
                            Stack(children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  imageUrl: "${widget.user?.image}",
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: MaterialButton(
                                  elevation: 1,
                                  onPressed: () {
                                    _showBottomSheet();
                                  },
                                  shape: const CircleBorder(),
                                  color: Colors.white,
                                  child: const Icon(Icons.edit,
                                      color: Colors.blue),
                                ),
                              )
                            ]),

                            /// for adding space
                            SizedBox(
                              width: mq.width,
                              height: mq.height * .03,
                            ),
                            Text(
                              "${widget.user?.email}",
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),

                            /// for adding space
                            SizedBox(
                              width: mq.width,
                              height: mq.height * .03,
                            ),
                            TextFormField(
                              initialValue: "${widget.user?.name}",
                              onSaved: (val) => Apis.me?.name = val ?? '',
                              validator: (val) => val != null && val.isNotEmpty
                                  ? null
                                  : 'Required Field',
                              decoration: InputDecoration(
                                  label: Text("Name"),
                                  hintText: "   e.g Happy Singh",
                                  prefix: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16))),
                            ),

                            /// for adding space
                            SizedBox(
                              width: mq.width,
                              height: mq.height * .03,
                            ),
                            TextFormField(
                              initialValue: "${widget.user?.about}",
                              onSaved: (val) => Apis.me?.about = val ?? '',
                              validator: (val) => val != null && val.isNotEmpty
                                  ? null
                                  : 'Required Field',
                              decoration: InputDecoration(
                                  label: const Text("About"),
                                  hintText: "e.g Happy Feelings ",
                                  prefix: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16))),
                            ),
                            SizedBox(
                              width: mq.width,
                              height: mq.height * .03,
                            ),

                            Container(
                              height: 56,
                              width: mq.width * .50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.blue),
                              child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    Apis.updateUserInfo().then((value) =>
                                        Dialogs.showSnackbar(context,
                                            "Profile Update Successfully"));
                                    log("in side validator");
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Update",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ))))));
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            // _image = image.path;
                          });

                          // APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            // _image = image.path;
                          });

                          // APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
