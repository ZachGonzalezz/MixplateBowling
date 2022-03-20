import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';

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
        Map<String, String> divisions =
            Map<String, String>.from(data['divisions'] ?? {});
        Map<String, dynamic> scoresDB =
            Map<String, dynamic>.from(data['scores'] ?? {});
        bool isMale = data['IsMale'] ?? false;
        Map<String, dynamic> partners = Map.from(data['doublePartners'] ?? {});

        Map<String, Map<String, int>> scores = {};

        scoresDB.forEach((squad, scoreMap) {
          scores[squad] = {};

          scoreMap.forEach((game, score) {
            scores[squad]![game] = score.toInt();
          });
        });

        bowlers[key] = Bowler(
            uniqueId: document.id,
            average: average.toDouble(),
            handicap: handicap.toDouble(),
            firstName: firstName,
            lastName: lastName,
            divisions: divisions,
            scores: scores,
            isMale: isMale);
      });
    });
    return;
  }

  int findTeamTotal(int outOf, int percent, List<int> gamesIncludes) {
    int total = 0;
    for (Bowler bowler in bowlers.values) {
      total +=
          bowler.findScoreForSquad(squad, outOf, percent, true, gamesIncludes);
    }
    return total;
  }

  int findTeamScratchTotal(int outOf, int percent, List<int> gamesIncludes) {
    int total = 0;
    for (Bowler bowler in bowlers.values) {
      total +=
          bowler.findScoreForSquad(squad, outOf, percent, false, gamesIncludes);
    }
    return total;
  }

  int findTeamTotalAverage() {
    int total = 0;
    for (Bowler bowler in bowlers.values) {
      total += bowler.average.toInt();
    }
    return total;
  }

  int findTeamTotalHandicap(int outOf, int percent) {
    int total = 0;
    for (Bowler bowler in bowlers.values) {
      total += bowler.findHandicap(outOf, percent);
    }
    return total;
  }

  int findTeamGameTOtal(String squad, int game) {
    int total = 0;
    for (Bowler bowler in bowlers.values) {
      total += bowler.findScoreForGame(squad, game);
    }
    return total;
  }
}
