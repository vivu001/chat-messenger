import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

class ChatScreen extends StatefulWidget {
  static const String id = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final _fireStore = Firestore.instance;
FirebaseUser _loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  // Authentication with Firebase
  final _auth = FirebaseAuth.instance;

  // Controller of TextField
  final mesTextHolder = TextEditingController();

//  FirebaseUser loggedInUser;
  String messageText;

  @override
  void initState() {
    super.initState();
    this.getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        _loggedInUser = user;
        print('LoggedIn User: ' + _loggedInUser.email);
      }
    } catch (e) {
      print('Exceptions: \n' + e.toString());
    }
  }

  void _clearTextField() {
    mesTextHolder.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBF8F5),
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('Chat 🤧 😷️ 🚑️ 🆘 🛌'),
        backgroundColor: Color(0xFF718C6A),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: mesTextHolder,
                      textInputAction: TextInputAction.send,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      print(messageText + ' ' + _loggedInUser.email + '!');
                      _fireStore
                          .collection('messages')
                          .add({'text': messageText, 'sender': _loggedInUser.email, 'time': DateTime.now()});
                      _clearTextField();
                    },
                    child: Icon(Icons.send, color: Color(0xFF344955)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<MessageBubble> messageBubbles = [];
        final messages = snapshot.data.documents.reversed;

        for (var mes in messages) {
          final mesText = mes.data['text'];
          final mesSender = mes.data['sender'];
          final mesTime = mes.data['time'];

          final mesBubble = MessageBubble(
              text: mesText, sender: mesSender, time: mesTime, isMe: _loggedInUser.email == mesSender);

          messageBubbles.add(mesBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

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
