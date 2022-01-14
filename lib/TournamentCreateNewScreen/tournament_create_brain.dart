import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentCreateBrain {
  static String isGoodtoCreate(
    String name,
    DateTime to,
    DateTime from,
  ) {
    if (name == '') {
      return 'You must give your tournament a name';
    }
    if (from.compareTo(to) == -1) {
      return 'Your tournament ends before it starts this';
    }
    return '';
  }

  static void createCourse(String name, DateTime to, DateTime from,
      List<String> emails, BuildContext context) async {
    DocumentReference ref = Constants.dataBase
        .collection('Users')
        .doc(Constants.currentSignedInEmail)
        .collection('Tournaments')
        .doc();
    ref.set({
      'to': to,
      'from': from,
      'name': name,
      'sharedWith': emails,
      'sidepots': [{}]
    });

    //this shares it to everyone person shared it with since tournamnets are stored under user/email/tournamnet/id they have to be manully added to each person
    //adds email so

    for (String email in emails) {
      Constants.dataBase
          .collection('Users')
          .doc(email)
          .collection('Tournaments')
          .doc(ref.id)
          .set({
        'to': to,
        'from': from,
        'name': name,
        'sharedWith': emails,
        'sidepots': [{}],
        //this will be used to see if it is shared with someone
        'isShared': true,
        //if it is shared then we will use this email in doucment address user/thisId/tourn/thisTournId (can do this bc we made them identical)
        'owner': Constants.currentSignedInEmail
      });
    }

    Constants.currentIdForTournament =
        'Users/${Constants.currentSignedInEmail}/Tournaments/${ref.id}';
    Constants.tournamentName = name;
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('tournamentId', Constants.currentIdForTournament);
    Navigator.pushNamed(context, Constants.settingsHome);
  }
}
