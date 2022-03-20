import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loisbowlingwebsite/TournamentSelectScreen.dart/tournament_selection_class.dart';
import 'package:loisbowlingwebsite/constants.dart';

class TournamentSelectBrain {
  Future<List<TournamentSelection>> getTournaments() async {
    List<TournamentSelection> tournaments = [];

    await Future.delayed(Duration(milliseconds: 500));

    await Constants.dataBase
        .collection('Users')
        .doc(Constants.currentSignedInEmail)
        .collection('Tournaments')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();

        Timestamp from = data['from'] ?? Timestamp.now();
        Timestamp to = data['to'] ?? Timestamp.now();
        List<String> emails = List.from(data['sharedWith'] ?? []);
        String name = data['name'] ?? '';
        bool isShared = data['isShared'] ?? false;
        String ownerEmail = data['owner'] ?? ' ';

        tournaments.add(TournamentSelection(
            name: name,
            start: from.toDate(),
            end: to.toDate(),
            sharedWith: emails,
            ownerEmail: ownerEmail,
            isShared: isShared,
            id: doc.id));
      });
    });

    return tournaments;
  }
}
