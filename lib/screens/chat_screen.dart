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

class _ChatScreenState extends State<ChatScreen> {
  // Cloud Firestore
  final _fireStore = Firestore.instance;

  // Authentication with Firebase
  final _auth = FirebaseAuth.instance;

  FirebaseUser loggedInUser;
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
        loggedInUser = user;
        print('LoggedIn User: ' + loggedInUser.email);
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

  final mesTextHolder = TextEditingController();

  void _clearTextField() {
    mesTextHolder.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Color(0xFF007791),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
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

                  final mesBubble =
                      MessageBubble(text: mesText, sender: mesSender, currentUser: loggedInUser);

                  messageBubbles.add(mesBubble);
//                  messageBubbles.add(SizedBox(height: 7));
                }

                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    children: messageBubbles,
                  ),
                );
              },
            ),
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
                      print(messageText + ' ' + loggedInUser.email + '!');
                      _fireStore
                          .collection('messages')
                          .add({'text': messageText, 'sender': loggedInUser.email});
                      _clearTextField();
                    },
                    child: Icon(Icons.send, color: Color(0xFF007791)),
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

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final FirebaseUser currentUser;

  MessageBubble({this.text, this.sender, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: Column(
        crossAxisAlignment: (sender == currentUser.email) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            (sender == currentUser.email) ? 'me' : sender,
            style: TextStyle(fontSize: 13.0, color: Color(0xFF8D6E63)),
          ),
          Material(
            borderRadius: BorderRadius.circular(15.0),
            elevation: 5.0,
            color: (sender == currentUser.email) ? Color(0xFFFF9800) : Color(0xFFA5D6A7),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: (sender == currentUser.email)
                  ? Text(text, style: kMessageStyle)
                  : Text(text, style: kMessageStyle.copyWith(color: Color(0xFF8D6E63))),
            ),
          ),
        ],
      ),
    );
  }
}
