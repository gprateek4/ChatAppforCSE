import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final _firestore = FirebaseFirestore.instance;
 String docId;
Map data;

class ViewVotes extends StatelessWidget {
  static const String id = 'view_votes';




  @override
  Widget build(BuildContext context) {


    // getDoc();
    return Scaffold(
      appBar: AppBar(
        title: Text('Votes'),
      ),
      body: Column(
        children: [
          Expanded(child: polls())
        ],
      ),
    );
  }
}

class polls extends StatefulWidget {

  @override
  State<polls> createState() => _pollsState();
}

class _pollsState extends State<polls> {

  void getDoc() {
    _firestore.collection('polls').doc(docId).get().then(
          (DocumentSnapshot doc) {
        print(docId);
        print('Rama');
        data = doc.data() as Map<String, dynamic>;
        print('sita');
        if(data.isEmpty) {
          print('Empty');
        } else{
          print(data.toString());
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      final List<String> args = ModalRoute.of(context).settings.arguments;
      docId =  args[0];
    });
    getDoc();
    return  StreamBuilder(
      stream: _firestore.collection('polls').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        getDoc();

         List opt= ['',''];
         opt[0]= data.keys.elementAt(2);
         data.keys.forEach((element) {
          if(element != 'question' && element != 'creator') {
            opt[0] = element;
          }
        });
         opt[1]= data.keys.elementAt(3);
        data.keys.forEach((element) {
          if(element != 'question' && element != 'creator' && element != opt[0]) {
            opt[1] = element;
          }
        });
        List<List> optnL=[];
        optnL.add( data[opt[0]] );
        optnL.add( data[opt[1]] );


        return ListView.separated(
          itemCount: 2,
          itemBuilder: (context, index){
            print('krishna');
            print(optnL[0]);
            print(optnL[1]);
            return ListTile(
              title: Text(opt[index]),
              subtitle: Text(optnL[index].toString()),
            );
          },
          separatorBuilder: (context, index){
            return SizedBox(height: 10,);
          },
        );


      }
    );
  }
}
