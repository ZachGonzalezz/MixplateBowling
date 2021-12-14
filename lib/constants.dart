import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Constants{

static Color lightBlue = const Color(0xFFEEF4FF);
static Gradient mainGradient = LinearGradient(
      colors: [
        const Color(0xFF5DB9FC),
        Colors.deepPurpleAccent.withOpacity(0.7)
      ],
      begin: const Alignment(-1, -1.0),
      end: const Alignment(1.0, 0.0),
      stops: const [0, 1]);


    static FirebaseFirestore dataBase =
   FirebaseFirestore.instance;

   static String currentSignedInEmail = 'Error';
   static String currentIdForTournament = '';
   static String tournamentName = '';
   static List<String> squads = ['A', 'B', 'C', 'D', 'E'];

   static String home = '/home';
   static String signUp = '/SignUp';
   static String tournamentHome = '/TournamentHome';
   static String tournamentCreate = '/TournamentHome/TournamentCreate';
   static String settingsHome = 'TournamentHome/TournamentCreate/settingsHome';
   static String settingsDivision = 'TournamentHome/TournamentCreate/settings/Divsion';

}