import 'package:flutter/material.dart';
import 'package:cse_chat/screens/welcome_screen.dart';
import 'package:cse_chat/screens/login_screen.dart';
import 'package:cse_chat/screens/registration_screen.dart';
import 'package:cse_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cse_chat/screens/splash.dart';
import 'package:cse_chat/poll/poll_screens/polls_home_screen.dart';
import 'package:cse_chat/poll/poll_screens/create_poll_screen.dart';
import 'package:cse_chat/screens/home_screen.dart';
import 'package:cse_chat/poll/poll_screens/view_votes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        CreatePoll.id: (context) => CreatePoll(),
        HomeScreen.id: (context) => HomeScreen(),
        PollsHomeScreen.id: (context) => PollsHomeScreen(),
        ViewVotes.id: (context) => ViewVotes(),
      },
    );
  }
}
