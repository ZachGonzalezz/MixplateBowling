import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentCreateBrain{

static String isGoodtoCreate(String name, DateTime to, DateTime from,){
if(name == ''){
  return 'You must give your tournament a name';
}
if(from.compareTo(to) == -1){
return 'Your tournament ends before it starts this';
}
return '';
}

static void createCourse(String name, DateTime to, DateTime from, List<String> emails, BuildContext context) async{

  DocumentReference ref = Constants.dataBase.collection('Users').doc(Constants.currentSignedInEmail).collection('Tournaments').doc();
  ref.set({
    'to' : to,
    'from' : from,
    'name' : name,
    'sharedWith' : emails,
     'sidepots' : [{}]
  });

        Constants.currentIdForTournament = 'Users/${Constants.currentSignedInEmail}/Tournaments/${ref.id}';
        Constants.tournamentName = name;
         final prefs = await SharedPreferences.getInstance();
      
      prefs.setString('tournamentId', Constants.currentIdForTournament);
        Navigator.pushNamed(context, Constants.settingsHome);
}

}