import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

import '../constants.dart';

class MessageBubble extends StatefulWidget {
  final String text;
  final String sender;
  final Timestamp time;
  final bool isMe;

  MessageBubble({this.text, this.sender, this.time, this.isMe});

  @override
  State<StatefulWidget> createState() => _MessageBubbleState(this);
}

class _MessageBubbleState extends State<MessageBubble> {
  final MessageBubble messageBubbleWidget;
  bool _showTime = false;

  _MessageBubbleState(this.messageBubbleWidget);

  void _changeLongPress() {
    setState(() {
      _showTime = !_showTime;
      print('ShowTime $_showTime !!!');
    });
  }

  @override
  Widget build(BuildContext context) {
    final String timeAgo = TimeAgo.getTimeAgo(messageBubbleWidget.time.millisecondsSinceEpoch);
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: Column(
        crossAxisAlignment: messageBubbleWidget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          (_showTime)
              ? Text(
                  timeAgo,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 11.0, color: Color(0xFF141518), fontStyle: FontStyle.italic),
                )
              : SizedBox(),
          Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: messageBubbleWidget.isMe ? Radius.circular(30) : Radius.circular(0),
                bottomRight: messageBubbleWidget.isMe ? Radius.circular(0) : Radius.circular(30)),
            elevation: 5.0,
            color: messageBubbleWidget.isMe ? Color(0xFFFF9800) : Color(0xFF4CAF50),
            child: InkWell(
              onLongPress: _changeLongPress,
              child: Container(
                  padding: EdgeInsets.all(7),
                  child: Column(
                    children: <Widget>[
                      // TODO: insert nickname sender?.replaceFirst(RegExp(r'\@[^]*'), '')
                      Text(messageBubbleWidget.text,
                          style: kMessageStyle,
                          textAlign: messageBubbleWidget.isMe ? TextAlign.end : TextAlign.start)
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
