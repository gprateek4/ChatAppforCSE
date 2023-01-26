import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cse_chat/components/rounded_button.dart';
import 'package:cse_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/chat_screen.dart';

class CreatePoll extends StatefulWidget {
  static const String id = 'create_poll_screen';
  @override
  State<CreatePoll> createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  final textFieldController = TextEditingController();
  final textFieldController1 = TextEditingController();
  final textFieldController2 = TextEditingController();

  int i=2,no_optn;
  String question;
  List<String> optionValue = ['',''];
  List<Function> options= [];
  List<Widget> btnList= [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void addOneMoreOption(){
    i++;
    optionValue.add('');
  }

  void getCurrentUser() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!\n user email: ${user.email} ');
          loggedInUser = user;
          // loggedInUserEmail = user.email;
        }
      });
    } catch (e) {
      print('catch block');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Poll',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              onChanged: (value) {
                question = value;
              },
              controller: textFieldController,
              decoration:
              kTextFieldDecoration.copyWith(hintText: 'Enter Question'),
            ),
            SizedBox(
              height: 12.0,
            ),
            Column(
              children : [
                ListView.separated(
                  padding: EdgeInsets.all(4),
                  itemCount: i,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return TextField(
                      onChanged: (value) {
                        optionValue[index] = value;
                        // print('value$i: $value');
                        // print('optionValue$i : $optionValue');
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter option ${index+1}'),
                    );
                  },
                  separatorBuilder: (context, index ){
                    return SizedBox( height: 9,);
                  },
                )
              ],
            ),

            SizedBox(
              height: 12.0,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RoundedButton(
          title: 'Save',
          colour: Colors.greenAccent,
          onPressed: (){
            print('que: $question');
            print('options : ${optionValue[0]}');
            print('options : ${optionValue[1]}');
            // Implement send functionality.
            if( loggedInUser == null ){
              print('logged in user NULL');
            } else {
              _firestore.collection('polls').add({
                'creator' : loggedInUser.email,
                'question': question,
                optionValue[0] : [],
                optionValue[1] : [],
              }
              );
            }
            setState(() {
              textFieldController.clear();
              textFieldController1.clear();
              textFieldController2.clear();
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}


// void getOptions(int i) {
//   TextField( // obscureText: true, //textAlign: TextAlign.center,
//     onChanged: (value) {
//       optionValue[i] = value;
//     },
//     decoration: kTextFieldDecoration.copyWith(
//         hintText: 'Enter option ${i+1}'),
//   );
//   i++;
// }

// TextField(
//   onChanged: (value) {
//     optionValue[0] = value;
//     print('value$i : $value');
//     print('optionValue$i : $optionValue');
//   },
//   decoration: kTextFieldDecoration.copyWith(
//       hintText: 'Enter option ${i+1}'),
// ),
// TextField(
//   onChanged: (value) {
//     optionValue[1] = value;
//     print('value$i : $value');
//     print('optionValue$i : $optionValue');
//   },
//   decoration: kTextFieldDecoration.copyWith(
//       hintText: 'Enter option ${i+1}'),
// ),
//btnList.add(
//       TextField(
//         onChanged: (value) {
//           optionValue[i] = value;
//           print('value$i: $value');
//           print('optionValue$i : $optionValue');
//         },
//         decoration: kTextFieldDecoration.copyWith(
//           hintText: 'Enter option ${i+1}'),
//       ),
//     );

// RoundedButton(
//   title: 'add option',
//   colour: Colors.blueAccent,
//   onPressed: (){
//     setState(() {
//       addOneMoreOption();
//     });
// },),