import 'package:flutter/material.dart';
import 'package:cse_chat/constants.dart';
import 'package:cse_chat/poll/poll_screens/create_poll_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cse_chat/main.dart';
import 'view_votes.dart';

final _firestore = FirebaseFirestore.instance;
String loggedInUserEmail;


class PollsHomeScreen extends StatefulWidget {

  static const String id = 'polls_home_screen';
  @override
  State<PollsHomeScreen> createState() => _PollsHomeScreenState();
}

class _PollsHomeScreenState extends State<PollsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: null,
        title: Container(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            maxHeight: double.infinity,
          ),
          child: GestureDetector(
            onTap: () {
              print('on tap detected');
              //Navigator.pushNamed(context, PollsHomeScreen.id);
            },
            child: Text(
              'Polls',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreatePoll.id);
        },
      ),
      body: DisplayPolls(),
    );
  }
}

class DisplayPolls extends StatefulWidget {
  @override
  State<DisplayPolls> createState() => _DisplayPollsState();
}

class _DisplayPollsState extends State<DisplayPolls> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children:[
          Expanded(child: MyPoll(),),
        ] )

    );
  }
}



class MyPoll extends StatefulWidget {

  @override
  State<MyPoll> createState() => _MyPollState();
}

class _MyPollState extends State<MyPoll> {

  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String que = 'que', opt1 = 'op1', opt2 = 'op2', selecedOpt, opts;
  List option = [];
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('polls').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          QuerySnapshot ddata = snapshot.data;
          List<QueryDocumentSnapshot> document = snapshot.data.docs;

          return ListView.separated(
            itemCount: document.length,
            itemBuilder: (context,index){
              int votes1, votes2;
              String que = document[index].get('question');
              Map<String, dynamic> map = document[index].data();
              String opt1= map.keys.elementAt(2);
              map.keys.forEach((element) {
                if(element != 'question' && element != 'creator') {
                  opt1 = element;
                }
              });
              String opt2= map.keys.elementAt(3);
              map.keys.forEach((element) {
                if(element != 'question' && element != 'creator' && element != opt1) {
                  opt2 = element;
                }
              });
              votes1 = map[opt1].length ;
              votes2 = map[opt2].length ;
              double votePercent1 = (votes1+votes2)!=0 ? votes1/(votes1+votes2)*100 : 0;
              double votePercent2 = (votes1+votes2)!=0 ? votes2/(votes1+votes2)*100 : 0;
              option.add('');

              return  Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 18),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                Column(
                  children: [
                    Text(
                      que,
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    Divider(),

                    RadioListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(opt1),
                          Text(votePercent1.toStringAsFixed(2)+'%'),
                          // Text(votes1.toString())
                        ],
                      ),
                      value: "op1",
                      groupValue: option[index],
                      onChanged: (value){
                        setState(() {
                          option[index]= value.toString();
                          document[index].reference.update({
                            opt1: FieldValue.arrayUnion([loggedInUser.email]),
                            opt2: FieldValue.arrayRemove([loggedInUser.email]),
                          });
                        });
                      },
                    ),

                    RadioListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(opt2),
                          Text(votePercent2.toStringAsFixed(2)+ '%' ),
                          // Text(votes2.toString()),
                        ],
                      ),
                      value: "op2",
                      groupValue: option[index],
                      onChanged: (value){
                        setState(() {
                          option[index]= value.toString();
                          document[index].reference.update({
                            opt1: FieldValue.arrayRemove([loggedInUser.email]),
                            opt2: FieldValue.arrayUnion([loggedInUser.email]),
                          });
                        });
                      },
                    ),

                    TextButton(
                      onPressed: (){
                        Navigator.pushNamed(
                            context,
                            ViewVotes.id,
                          arguments: [ document[index].id ],
                        );
                      },
                      child: Text('View Votes'))
                  ],
                ),
              );

            },
            separatorBuilder: (context, index){
              return SizedBox(height: 2,);
            },
          );

        }

    );
  }
}







//   Container(
//   padding: EdgeInsets.all(10),
//   child:
//   Column(
//     children: [
//       Text(
//         que,
//         style: TextStyle(
//             fontSize: 18
//         ),
//       ),
//       Divider(),
//       RadioListTile(
//         title: Text(opt1),
//         value: "op1",
//         groupValue: option,
//         onChanged: (value){
//           setState(() {
//             option = value.toString();
//           });
//         },
//       ),
//       RadioListTile(
//         title: Text(opt2),
//         value: "op2",
//         groupValue: option,
//         onChanged: (value){
//           setState(() {
//             option = value.toString();
//           });
//         },
//       ),
//     ],
//   ),
// ) ;


//Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Radio(
//                             value: opt1,
//                             groupValue: radioGrpVal,
//                             onChanged: (val){
//                               selecedOpt=val;
//                             },
//                         ),
//                       ),
//                       Expanded(
//                         flex: 5,
//                         child: Container(
//                           width: double.infinity,
//                           child: Stack(
//                             children: [
//                               LinearProgressIndicator(
//                                 value: 9/100,
//                                 minHeight: 24,
//                                 backgroundColor: Colors.white,
//                                 semanticsLabel: 'option1',
//                                 semanticsValue: 'op1',
//                               ),
//                               Text(
//                                 opt1,
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//Column(
//                 children: [
//                   Text(
//                     que,
//                     style: kSendButtonTextStyle,
//                   ),
//                   SizedBox(height: 12,),
//                   Row(
//                     children: [
//                       RadioListTile(
//                         value: opt1,
//                         groupValue: radioGrpVal,
//                         onChanged: (val){
//                           selecedOpt=val.toString();
//                         },),
//                       Expanded(
//                         child: Stack(
//                             children: [
//                               LinearProgressIndicator(
//                                 value: 42/100,
//                                 minHeight: 24,
//                                 semanticsLabel: 'option2',
//                               ),
//                               Text(
//                                 opt1,
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               )
//                             ]
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10,),
//                   Row(
//                     children: [
//                       RadioListTile(
//                           value: opt2,
//                           groupValue: radioGrpVal,
//                           onChanged: (val){
//                             radioGrpVal=val.toString();
//                           },),
//                       Expanded(
//                         child: Stack(
//                           children: [
//                             LinearProgressIndicator(
//                               value: 42/100,
//                               minHeight: 24,
//                               semanticsLabel: 'option1',
//                             ),
//                             Text(
//                               opt2,
//                               style: TextStyle(
//                                 fontSize: 20,
//                               ),
//                             )
//                           ]
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),