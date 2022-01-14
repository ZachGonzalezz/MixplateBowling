import 'package:lois_bowling_website/bowler.dart';
import 'package:lois_bowling_website/doublePartner.dart';

class DoubleSearchBrain {
  List<DoublePartners> findDoublePartnes(List<Bowler> allBowlers,
      List<Bowler> results, String? squad, String? divison) {
    List<DoublePartners> doublePartners = [];
    List<DoublePartners> temp = [];

    //goes through each of the bowlers find the double partners and make a list
    for (Bowler bowler in allBowlers) {
      bowler.doublePartners.forEach((key, value) {
        for (String partnerId in value) {
          temp.add(DoublePartners(
              bowlersid: [bowler.uniqueId, partnerId], squad: key));
        }
      });
    }

    for (DoublePartners doubleTeam in temp) {
      List<Bowler> bowlersOnteam = [];
      for (Bowler bowler in allBowlers) {
        if (doubleTeam.bowlersid.contains(bowler.uniqueId)) {
          bowlersOnteam.add(bowler);
        }
      }
      doubleTeam.bowlers = bowlersOnteam;

      if (doublePartners.contains(doubleTeam) != true) {
        //find the index of bowler in list of bowlers given unique id

        doublePartners.add(doubleTeam);
      }
    }

    //ensures that each doubles has atleast 2 people and matches the results for

    doublePartners = doublePartners
        .where((element) =>
            element.bowlers.length > 1 &&
                results.contains(element.bowlers[1]) ||
            results.contains(element.bowlers[0]))
        .toList();

    if (divison?.contains('No Division') != true && divison != null) {
      doublePartners = doublePartners
          .where((element) =>
              element.bowlers[0].divisions[(squad! + 'Doubles')] == divison ||
              element.bowlers[1].divisions[(squad + 'Doubles')] == divison)
          .toList();
    }

    //we are saying only return those that have 2 bowlers and atleast one of them must be contained in the search results of bowlers
    return doublePartners;
  }
}
