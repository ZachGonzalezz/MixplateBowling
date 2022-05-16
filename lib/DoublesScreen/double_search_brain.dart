import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/doublePartner.dart';

class DoubleSearchBrain {
  List<DoublePartners> findDoublePartnes(List<Bowler> allBowlers,
      List<Bowler> results, String? squad, String? divison) {
    List<DoublePartners> doublePartners = [];
    List<DoublePartners> temp = [];
    List<String> oldIds = [];

    //goes through each of the bowlers find the double partners and make a list
    for (Bowler bowler in allBowlers) {
      bowler.doublePartners.forEach((key, value) {
        for (String partnerId in value) {
          List<String> ids = [bowler.uniqueId, partnerId];
          ids.sort((a, b) => a.compareTo(b));
      
          if(oldIds.contains(ids[1] + ids[0]) != true){

            
            
          temp.add(DoublePartners(
              bowlersid: ids, squad: key));
                  oldIds.add(ids[1] + ids[0]);
          }
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

    // doublePartners = removeDuplicates(doublePartners);

    //we are saying only return those that have 2 bowlers and atleast one of them must be contained in the search results of bowlers
    return doublePartners;
  }

  List<DoublePartners> removeDuplicates(List<DoublePartners> currentList){

    List<DoublePartners> newList = [];


      for (DoublePartners oldDoubles in currentList) {

        // oldDoubles.bowlers.sort((a, b) => a.uniqueId.compareTo(a.uniqueId));
        // oldDoubles.bowlersid.sort((a, b) => a.compareTo(b));
        // oldDoubles.squad = 'A';

        if(newList.isEmpty ){
          newList.add(oldDoubles);
        }


        



     
        
        // }
      
    }

    return newList;

  }
}
