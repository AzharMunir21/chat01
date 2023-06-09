import 'dart:developer';

import 'package:chat01/Model/ChatUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis {
  /// for uthentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// for accesing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// to return current user
  static User get user => auth.currentUser!;

  /// for checking user exist or not
  static Future<bool> userExist() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  static CharUser? me;

  /// for checking user exist or not
  static Future<void> getSelfInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = CharUser.fromJson(user.data()!);
        // log("My data ${user.data()!["password"]}");
      } else {
        log("My data ${user.data()!}");
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  /// create a new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = CharUser(
      id: user.uid,
      image: user.photoURL,
      name: user.displayName,
      about: "Hi im Using We chat",
      createAt: time,
      email: user.email,
      isOnline: false,
      lastActive: time,
      pushToken: "",
    );
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  /// get all users from firestore database

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection("users")
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  ///  user update information
  static Future<void> updateUserInfo() async {
    await firestore.collection("users").doc(user.uid).update({
      "name": me?.name,
      "about": me?.about,
    });
  }
}
