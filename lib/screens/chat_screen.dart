import 'package:flutter/material.dart';
import 'package:cse_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../poll/poll_screens/polls_home_screen.dart';

final _firestore = FirebaseFirestore.instance;
String loggedInUserEmail;

class ChatScreen extends StatefulWidget {

  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textFeildController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String messageText;
  @override
  void initState()
  {
    super.initState();
    print('In init');
    getCurrentUser();
  }

  void getCurrentUser() async
  {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!\n user email: ${user.email} ');
          loggedInUser = user;
          loggedInUserEmail = user.email;
        }
      });
    } catch (e) {
      print('catch block');
    }
  }

  void messagesStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()) {
      for( var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Container(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            maxHeight: double.infinity,
          ),
          child: GestureDetector(
            onTap: (){
              print('on tap detected');
              messagesStream();
              Navigator.pushNamed(context, PollsHomeScreen.id);
            },
            child: Text(
                'Chat',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],

        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: MessageStream(),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFeildController,
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      if( loggedInUser == null ){
                        print('logged in user NULL');
                      } else {
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'email' : loggedInUser.email,
                        });
                      }
                      textFeildController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        List<QueryDocumentSnapshot> document = snapshot.data.docs ;
        return ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: document.length,
          itemBuilder: (context, index){
            String text = document[index].get('text');
            String email = document[index].get('email');
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: email==loggedInUserEmail ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    email,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54
                    ),
                  ),
                  Container(
                      margin: email==loggedInUserEmail ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: email==loggedInUserEmail ? Colors.lightBlueAccent : Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: email==loggedInUserEmail? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),),
                ],
              )

            );
          },
        );
      },
    );
  }
}

// Column(
//                 crossAxisAlignment: email==loggedInUserEmail ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     email,
//                     style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.black54
//                     ),
//                   ),
//                   Material(
//                       elevation: 4,
//                       borderRadius: BorderRadius.all(Radius.circular(7)),
//                       // BorderRadius.only(
//                       //   topRight: Radius.circular(10),
//                       //   bottomLeft: Radius.circular(10),
//                       //   topLeft: Radius.circular(10),
//                       // ),
//                       color: email==loggedInUserEmail ? Colors.lightBlueAccent : Colors.white54,
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
//                         child: Text(
//                           text,
//                           style: TextStyle(
//                             color: email==loggedInUserEmail? Colors.black : Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                       )),
//                 ],
//               )



// BorderRadius.only(
//   topRight: Radius.circular(10),
//   bottomLeft: Radius.circular(10),
//   topLeft: Radius.circular(10),
// ),

// {
//   try{
//     print('in TRY CATCH.');
//     final user = await _auth.currentUser;
//     if(user != null )
//     {
//       print("E - Mail : $user.email");
//       loggedInUser =user;
//     }else {
//       print('user == NULL');
//     }
//   }catch(e){
//     print("try catch");
//     print(e);
//   }
// }
