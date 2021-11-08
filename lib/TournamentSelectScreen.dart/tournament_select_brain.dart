import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lois_bowling_website/TournamentSelectScreen.dart/tournament_selection_class.dart';
import 'package:lois_bowling_website/constants.dart';

class TournamentSelectBrain{

  Future<List<TournamentSelection>> getTournaments() async{
    List<TournamentSelection> tournaments = [];

   await Constants.dataBase.collection('Users').doc(Constants.currentSignedInEmail).collection('Tournaments').get().then((querySnapshot) {

     querySnapshot.docs.forEach((doc) {
       Map<String, dynamic> data = doc.data();

        Timestamp from = data['from'] ?? Timestamp.now();
        Timestamp to = data['to'] ?? Timestamp.now();
        List<String> emails = List.from(data['sharedWith'] ?? []);
        String name = data['name'] ?? '';

        tournaments.add(TournamentSelection(name: name, start: from.toDate(), end: to.toDate(), sharedWith: emails, id: doc.id));
     });

    });

    return tournaments;
  } 

}