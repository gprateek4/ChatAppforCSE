import 'package:flutter/material.dart';
import 'package:cse_chat/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.lightBlueAccent,
          body: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                alignment: Alignment.center,
                decoration: BoxDecoration(

                ),
                child: Text(
                  'Messages',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView.separated(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                          'group$index',
                          style: TextStyle(
                            
                          ),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, ChatScreen.id ) ;
                        },
                      );
                    },
                    separatorBuilder: (context, index){
                      return SizedBox(height: 2,);
                    },
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
