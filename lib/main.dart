
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lois_bowling_website/AddDoublePartner/add_double.dart';
import 'package:lois_bowling_website/CreateBowler/create_new_screen.dart';
import 'package:lois_bowling_website/DoublesScreen/double_search.dart';
import 'package:lois_bowling_website/FinanceScreen/finaceScreen.dart';
import 'package:lois_bowling_website/InputScores/Input_Scores.dart';
import 'package:lois_bowling_website/LoginScreen/login_screen.dart';
import 'package:lois_bowling_website/SearchBowlers/SearchBowler.dart';
import 'package:lois_bowling_website/SettingsScreen/DivisionSettings/settings_division.dart';
import 'package:lois_bowling_website/SettingsScreen/SidePotScreen/sidepotscreen.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_home.dart';
import 'package:lois_bowling_website/SignupScreen/signup_screen.dart';
import 'package:lois_bowling_website/SinglesScreen/search_singles.dart';
import 'package:lois_bowling_website/TeamSearch/team_search.dart';
import 'package:lois_bowling_website/TeamsCreate/team_create_screen.dart';
import 'package:lois_bowling_website/TournamentCreateNewScreen/tournament_createnew_screen.dart';
import 'package:lois_bowling_website/TournamentSelectScreen.dart/select_tourn_screen.dart';
import 'package:lois_bowling_website/constants.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


//this means user is to stayed signed in accross sessions
await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
//this check user state when user refreshes the page this called reset the value
FirebaseAuth.instance.authStateChanges().listen((event) {
  Constants.currentSignedInEmail = event?.email ?? 'Error';
  
});
 
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
        Constants.settingsDivision : (context) => DivisionSettingsHome(),
        Constants.createNewBowler : (context) => CreateNewBowlerScreen(),
        Constants.doublesSearch : (context) => AddDoublePartnerScreen(),
        Constants.teamCreate : (context) => TeamCreateScreen(),
        Constants.teamSearch : (context) => TeamSearchScreen(isCreatingNewBowler: false,),
        Constants.inputScores : (context) => InputScoreScreen(),
        Constants.searchBowlers : (context) => SearchBowlerScreen(),
        Constants.searchDoubles : (context) =>SearchDoublesScreen(),
        Constants.searchSingles : (context) => SearchSinglesScreen(),
        Constants.sidePotSettings : (context) => SidePotScreen(),
        Constants.financeScreen : (context) => FinanceScreen(),



      },
      debugShowCheckedModeBanner: false,
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
