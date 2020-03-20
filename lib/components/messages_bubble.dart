import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_screen.dart';
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
  final MessageBubble _messageBubbleWidget;

  bool _showTime = false;

  _MessageBubbleState(this._messageBubbleWidget);

  void _changeLongPress() {
    setState(() {
      _showTime = !_showTime;
      print('ShowTime $_showTime !!!');
    });
  }

/*  Color _color;

  void _getColorFromUser(String sender) {
    _color = otherUsersColors[sender];
  }*/

  @override
  Widget build(BuildContext context) {
    final String timeAgo = TimeAgo.getTimeAgo(_messageBubbleWidget.time.millisecondsSinceEpoch);
  /*  setState(() {
      _getColorFromUser(_messageBubbleWidget.sender);
    });*/
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: Column(
        crossAxisAlignment: _messageBubbleWidget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                bottomLeft: _messageBubbleWidget.isMe ? Radius.circular(30) : Radius.circular(0),
                bottomRight: _messageBubbleWidget.isMe ? Radius.circular(0) : Radius.circular(30)),
            elevation: 5.0,
            color: _messageBubbleWidget.isMe ? Color(0xFFFF9800) : Color(0xFFaa00c7),
            child: InkWell(
              onLongPress: _changeLongPress,
              child: Container(
                  padding: EdgeInsets.all(7),
                  child: Column(
                    children: <Widget>[
                      // TODO: insert nickname sender?.replaceFirst(RegExp(r'\@[^]*'), '')
                      Text(_messageBubbleWidget.text,
                          style: kMessageStyle,
                          textAlign: _messageBubbleWidget.isMe ? TextAlign.end : TextAlign.start)
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
