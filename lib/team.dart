import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lois_bowling_website/bowler.dart';
import 'package:lois_bowling_website/constants.dart';

class Team {
  Team(
      {this.division = '',
      this.squad = '',
      this.name = '',
      this.bowlerIDs = const {},
      this.bowlers = const {},
      this.id = ''});

  String division;
  String id;
  Map<String, String> bowlerIDs;
  String name;
  String squad;
  Map<String, Bowler> bowlers;

  Future<void> loadBowlers() async {
    await Constants.getTournamentId();

    await Future.forEach(bowlerIDs.keys, (String key) async {
    
      await FirebaseFirestore.instance
          .doc(Constants.currentIdForTournament)
          .collection('Bowlers')
          .doc(bowlerIDs[key]!)
          .get()
          .then((document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        num average = data['average'] ?? 0;
        num handicap = data['handicap'] ?? 0;
        String firstName = data['firstName'] ?? ' ';
        String lastName = data['lastName'] ?? ' ';
        

        bowlers[key] = Bowler(
          uniqueId: document.id,
          average: average.toDouble(),
          handicap: handicap.toDouble(),
          firstName: firstName,
          lastName: lastName,
        
        );
        print(bowlers);
      });
    });
    return;
  }
}
