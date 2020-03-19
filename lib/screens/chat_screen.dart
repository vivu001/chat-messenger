import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/messages_bubble.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final _mesTextHolder = TextEditingController();

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
    _mesTextHolder.clear();
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
                      controller: _mesTextHolder,
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
        final messages = snapshot.data.documents;
        /*    messages.sort((a, b) {
          Timestamp timestampA = a.data['time'];
          Timestamp timestampB = b.data['time'];
          return timestampA.compareTo(timestampB);
        });*/

        // sort all messages by time
        messages.sort((a, b) => (b.data['time'] as Timestamp).compareTo(a.data['time'] as Timestamp));

        for (var mes in messages) {
          final mesText = mes.data['text'];
          final mesSender = mes.data['sender'];
          final Timestamp mesTime = mes.data['time'];

          final mesBubble = MessageBubble(
              text: mesText, sender: mesSender, time: mesTime, isMe: _loggedInUser.email == mesSender);

          messageBubbles.add(mesBubble);
        }

        return Expanded(
          child: Scrollbar(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              children: messageBubbles,
            ),
          ),
        );
      },
    );
  }
}
