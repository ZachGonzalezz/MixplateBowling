import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lois_bowling_website/bowler.dart';
import 'package:lois_bowling_website/constants.dart';

class TeamBrain {

  Future<void> saveNewTeam({ required String name, required Map<int, Bowler> teamMembers}) async {

       await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Teams').doc().set({
          'Name' : name,
          'Members' : getBowlerIds(teamMembers)
        });

    return;
  }

  Map<String, String> getBowlerIds(Map<int, Bowler> teamMembers)  {

    Map<String, String> ids = {};

    teamMembers.forEach((key, value) { 
      ids[key.toString()] = value.uniqueId;
    });
    return ids;
  }

   Future<void> updateATeam({ required String name, required Map<int, Bowler> teamMembers, required String id}) async {

       await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Teams').doc(id).update({
          'Name' : name,
          'Members' : teamMembers
        });

    return;
  }

}

 

