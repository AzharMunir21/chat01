import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Api/api.dart';
import '../Model/ChatUser.dart';
import '../Widget/chat_user_card.dart';
import '../main.dart';
import 'auth/ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// for storing all users
  List<CharUser> _list = [];

  /// for storing search item
  final List<CharUser> _searchList = [];

  /// for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = !_isSearching;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                  },
                  child: const Icon(Icons.add_comment_rounded),
                ),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: const Icon(
                    CupertinoIcons.home,
                    color: Colors.black,
                  ),
                  title: _isSearching
                      ? TextField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name..Email"),
                          autofocus: true,
                          style:
                              const TextStyle(fontSize: 16, letterSpacing: 1),
                          onChanged: (val) {
                            /// search logic
                            _searchList.clear();
                            for (var i in _list) {
                              if (i.name!
                                      .toLowerCase()
                                      .contains(val.toLowerCase()) ||
                                  i.email!
                                      .toLowerCase()
                                      .contains(val.toLowerCase())) {
                                _searchList.add(i);
                              }
                              setState(() {
                                _searchList;
                              });
                            }
                          },
                        )
                      : const Text("We Chat"),
                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                        },
                        icon: Icon(
                          _isSearching
                              ? CupertinoIcons.clear_circled_solid
                              : Icons.search,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ProfileScreen(user: Apis.me)));
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ))
                  ],
                ),
                body: SizedBox(
                    height: mq.height,
                    width: mq.width,
                    child: StreamBuilder(
                        stream: Apis.getAllUser(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            /// if data is loading
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const Center(
                                  child: CircularProgressIndicator());

                            /// if all data is loaded then show it
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _list = data
                                      ?.map((e) => CharUser.fromJson(e.data()))
                                      .toList() ??
                                  [];
                              if (_list.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: _isSearching
                                      ? _searchList.length
                                      : _list.length,
                                  physics: const BouncingScrollPhysics(),
                                  padding:
                                      EdgeInsets.only(top: mq.height * .01),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _isSearching
                                        ? ChatUserCard(
                                            user: _searchList[index],
                                          )
                                        : ChatUserCard(
                                            user: _list[index],
                                          );
                                  },
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: _list.length,
                                  physics: const BouncingScrollPhysics(),
                                  padding:
                                      EdgeInsets.only(top: mq.height * .01),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text("Name ${_list[index]}");
                                    // ChatUserCard();
                                  },
                                );
                              }
                          }
                        })))));
  }
}
