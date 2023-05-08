import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/AddDoublePartner/add_double.dart';
import 'package:loisbowlingwebsite/Brackets/brackets_screen.dart';
import 'package:loisbowlingwebsite/CreateBowler/create_new_screen.dart';
import 'package:loisbowlingwebsite/DoublesScreen/double_search.dart';
import 'package:loisbowlingwebsite/FinanceScreen/finaceScreen.dart';
import 'package:loisbowlingwebsite/InputScores/Input_Scores.dart';
import 'package:loisbowlingwebsite/LoginScreen/login_screen.dart';
import 'package:loisbowlingwebsite/SearchBowlers/SearchBowler.dart';
import 'package:loisbowlingwebsite/SettingsScreen/DivisionSettings/settings_division.dart';
import 'package:loisbowlingwebsite/SettingsScreen/SidePotScreen/sidepotscreen.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_home.dart';
import 'package:loisbowlingwebsite/SignupScreen/signup_screen.dart';
import 'package:loisbowlingwebsite/SinglesScreen/search_singles.dart';
import 'package:loisbowlingwebsite/TeamSearch/team_search.dart';
import 'package:loisbowlingwebsite/TeamsCreate/team_create_screen.dart';
import 'package:loisbowlingwebsite/TournamentCreateNewScreen/tournament_createnew_screen.dart';
import 'package:loisbowlingwebsite/TournamentSelectScreen.dart/select_tourn_screen.dart';
import 'package:loisbowlingwebsite/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: 'AIzaSyB8O3477HeaIclWx52H8W9RHcy6noBX7UU', appId: '1:276175805543:web:2d1902fe32528d6cac48c2', messagingSenderId: '276175805543', projectId: 'bowling-app-70561')
  );

  if (kIsWeb) {
//this means user is to stayed signed in accross sessions
    // await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
//this check user state when user refreshes the page this called reset the value
    // FirebaseAuth.instance.authStateChanges().listen((event) {
    //   Constants.currentSignedInEmail = event?.email ?? 'Error';
    // });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Constants.home: (context) => const LoginScreen(),
        Constants.signUp: (context) => SignUpScreen(),
        Constants.tournamentHome: (context) => SelectTournamentScreen(),
        Constants.tournamentCreate: (context) => TournamentCreatenewScreen(),
        Constants.settingsHome: (context) => SettingsHome(),
        Constants.settingsDivision: (context) => DivisionSettingsHome(),
        Constants.createNewBowler: (context) => CreateNewBowlerScreen(),
        Constants.doublesSearch: (context) => AddDoublePartnerScreen(),
        Constants.teamCreate: (context) => TeamCreateScreen(),
        Constants.teamSearch: (context) => TeamSearchScreen(
              isCreatingNewBowler: false,
            ),
        Constants.inputScores: (context) => InputScoreScreen(),
        Constants.searchBowlers: (context) => SearchBowlerScreen(),
        Constants.searchDoubles: (context) => SearchDoublesScreen(),
        Constants.searchSingles: (context) => SearchSinglesScreen(),
        Constants.sidePotSettings: (context) => SidePotScreen(),
        Constants.financeScreen: (context) => FinanceScreen(),
        Constants.brackets: (context) => BracketScreen()
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
