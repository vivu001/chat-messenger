import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  /*  void messagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }*/

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
                          .add({'text': messageText, 'sender': _loggedInUser.email});
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

        for (var mes in messages) {
          final mesText = mes.data['text'];
          final mesSender = mes.data['sender'];

          final mesBubble = MessageBubble(text: mesText, sender: mesSender);

          messageBubbles.add(mesBubble);
        }

        return Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;

  MessageBubble({this.text, this.sender});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: Column(
        crossAxisAlignment:
            (sender == _loggedInUser.email) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: (sender == _loggedInUser.email) ? Radius.circular(30) : Radius.circular(0),
                bottomRight: (sender == _loggedInUser.email) ? Radius.circular(0) : Radius.circular(30)),
            elevation: 5.0,
            color: (sender == _loggedInUser.email) ? Color(0xFFFF9800) : Color(0xFF4CAF50),
            child: Container(
                padding: EdgeInsets.all(7),
                child: Column(
                  children: <Widget>[
                    // TODO: insert nickname sender?.replaceFirst(RegExp(r'\@[^]*'), '')
                    /*Text(
                      textAlign: (sender == _loggedInUser.email) ? TextAlign.right : TextAlign.left,
                      style: TextStyle(fontSize: 11.0, color: Color(0xFF141518), fontStyle: FontStyle.italic),
                    ),*/
                    Text(text,
                        style: kMessageStyle,
                        textAlign: (sender == _loggedInUser.email) ? TextAlign.end : TextAlign.start)
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
