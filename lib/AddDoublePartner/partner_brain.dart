import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lois_bowling_website/bowler.dart';
import 'package:lois_bowling_website/constants.dart';

class DoublePartner {
  static List<Bowler> filterBowlers(
      {required List<Bowler> bowlers,
      required String? search,
      required int outOf,
      required int percent,
      String? divison,
      String? squad,
      String? type}) {
    List<Bowler> filtered = [];

    //if the search bar is empty send them back to default
    if (search == '' || search == null || search == ' ') {
      filtered = bowlers;
    } else {
      //search through the names of all the bowlers and see which one contains the search text
      for (Bowler bowler in bowlers) {
        //completely lowercases so removes that out of the equation
        if (bowler.firstName.toLowerCase().contains(search.toLowerCase()) ||
            bowler.lastName.toLowerCase().contains(search.toLowerCase())) {
          filtered.add(bowler);
      
        }
      }
    }

    //if division if not null only return those bowlers who meet search have division requirement

    filtered.sort((a, b) => b
        .findScoreForSquad(squad ?? '', outOf, percent, true)
        .compareTo(a.findScoreForSquad(squad ?? '', outOf, percent, true)));

    if (divison?.contains('No Division') != true &&
        divison != null &&
        type != null) {
      filtered = filtered
          .where((element) => element.divisions[(squad! + type)] == divison)
          .toList();
    }
    //returns results of bowlers
    return filtered;
  }

  static Future<List<Bowler>> loadBowlers() async {
    List<Bowler> bowlers = [];
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Bowlers')
        .get()
        .then((documents) {
      for (DocumentSnapshot doc in documents.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
        Map<String, dynamic> sidepotsDB = Map.from(data['userSidePots'] ?? {});
        Map<String, dynamic> financesDB = Map.from(data['financesPaid'] ?? {});
        String lanenNum = data['laneNum'] ?? '';
        String usbcNum = data['usbcNum'] ?? '';

        Map<String, Map<String, int>> scores = {};

        scoresDB.forEach((squad, scoreMap) {
          scores[squad] = {};

          scoreMap.forEach((game, score) {
            scores[squad]![game] = score.toInt();
          });
        });

        bowlers.add(Bowler(
            uniqueId: doc.id,
            average: average.toDouble(),
            handicap: handicap.toDouble(),
            firstName: firstName,
            lastName: lastName,
            divisions: divisions,
            scores: scores,
            isMale: isMale,
            doublePartners: partners,
            sidepots: sidepotsDB,
            financesPaid: financesDB,
            laneNUm: lanenNum,
            uscbNum: usbcNum));
      }
    });

    return bowlers;
  }
}