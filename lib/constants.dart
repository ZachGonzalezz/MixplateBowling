import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static Color lightBlue = const Color(0xFFEEF4FF);
  static Gradient mainGradient = LinearGradient(
      colors: [
        const Color(0xFF5DB9FC),
        Colors.deepPurpleAccent.withOpacity(0.7)
      ],
      begin: const Alignment(-1, -1.0),
      end: const Alignment(1.0, 0.0),
      stops: const [0, 1]);

  static FirebaseFirestore dataBase = FirebaseFirestore.instance;

  static String currentSignedInEmail = 'Error';
  static String currentIdForTournament = '';
  static String tournamentName = '';
  static List<String> squads = ['A', 'B', 'C', 'D', 'E'];

  static String home = '/home';
  static String signUp = '/SignUp';
  static String tournamentHome = '/TournamentHome';
  static String tournamentCreate = '/TournamentHome/TournamentCreate';
  static String settingsHome = 'TournamentHome/TournamentCreate/settingsHome';
  static String createNewBowler =
      'TournamentHome/TournamentCreate/settingsHome/CreateNew';
  static String settingsDivision =
      'TournamentHome/TournamentCreate/settings/Divsion';

  static void saveTournamentIdBeforeRefresh() {
    html.window.onBeforeUnload.listen((event) async {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('tournamentId', Constants.currentIdForTournament);
      // do what u got to do here
    });
  }

  static Future<void> getTournamentId() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // /Users/1@2.com/Tournaments/obZBlDBVqZzpomqPTPUU
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the counter key. If it doesn't exist, return 0.
    final cachedTournamentId = prefs.getString('tournamentId') ?? ' ';

    Constants.currentIdForTournament = cachedTournamentId;
    return;
  }

  static List<String> squadOptions = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  static List<String> findSquads(int numberOfSquads) {
    return squadOptions.getRange(0, numberOfSquads).toList();
  }

//takes in a list of divisions find all the ones in that one squad
  static List<String> findDivisionInSquad(
      List<String> divisions, String squadLookingFor) {
    List<String> divisionsFound = ['  No Division'];

    divisions.forEach((division) {
      if (division.substring(0, 1) == squadLookingFor) {
        divisionsFound.add(division);
      }
    });

    return divisionsFound;
  }
}
