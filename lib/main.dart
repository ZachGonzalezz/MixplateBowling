
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lois_bowling_website/LoginScreen/login_screen.dart';
import 'package:lois_bowling_website/SettingsScreen/DivisionSettings/settings_division.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_home.dart';
import 'package:lois_bowling_website/SignupScreen/signup_screen.dart';
import 'package:lois_bowling_website/TournamentCreateNewScreen/tournament_createnew_screen.dart';
import 'package:lois_bowling_website/TournamentSelectScreen.dart/select_tourn_screen.dart';
import 'package:lois_bowling_website/constants.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      routes: {
        Constants.home : (context) => const LoginScreen(),
        Constants.signUp : (context) => SignUpScreen(),
        Constants.tournamentHome : (context) => SelectTournamentScreen(),
        Constants.tournamentCreate : (context) => TournamentCreatenewScreen(),
        Constants.settingsHome : (context) => SettingsHome(),
        Constants.settingsDivision : (context) => DivisionSettingsHome()


      },
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
   // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
