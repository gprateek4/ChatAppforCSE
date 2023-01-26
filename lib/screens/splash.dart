
import 'dart:async';

import 'package:cse_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';



class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  SplashScreen({  @required this.title}) ;



  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool is_visible= false;
  _SplashScreenState(){
    new Timer(const Duration(milliseconds: 2500), (){
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomeScreen()), (route) => false);
      });
    });
    new Timer(
        Duration(milliseconds: 50), (){
      setState(() {
        is_visible=true;
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops:[0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: is_visible ? 1.0 : 0, duration: Duration(milliseconds: 500),
        child: Center(
          child: Container(
            height: 150.0,
            width: 150.0,
            child: Center(
              child: ClipOval(
                child: Hero(
                  tag: 'logo',
                  child: Container(

                    height: 500.0,
                    child: Image.asset('images/img04.png'),

                  ),


                )
              ),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5.0,
                    offset: Offset(5, 3),
                    spreadRadius: 3.0,
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}
