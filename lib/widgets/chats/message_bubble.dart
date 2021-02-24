import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.username, this.isMe,
  {this.key}
      );
  final String message;
  final isMe;
  final String username;
  final key;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
                bottomLeft: !isMe ? Radius.circular(0.0) : Radius.circular(12.0),
                bottomRight: isMe ? Radius.circular(0.0) : Radius.circular(12.0)),
          ),
          width: MediaQuery.of(context).size.width * 0.5,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
                  Text(username, style: TextStyle(fontWeight: FontWeight.bold, color: isMe
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.headline1.color),),



              Text(
                message,
                style: TextStyle(
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline1.color),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
