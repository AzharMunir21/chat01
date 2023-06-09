import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Model/ChatUser.dart';
import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final CharUser? user;
  ChatUserCard({this.user});
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
        child: InkWell(
          child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .03),
                child: CachedNetworkImage(
                  width: mq.height * .055,
                  height: mq.height * .055,
                  imageUrl: "${widget.user?.image}",
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),

              /// user name
              title: Text("${widget.user?.name}"),

              ///Last user Message
              subtitle: Text("${widget.user?.about}"),

              /// Last user message time
              trailing: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.greenAccent.shade400,
              )
              // Text("12:00 PM"),
              ),
        ));
  }
}
