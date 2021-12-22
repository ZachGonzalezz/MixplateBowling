import 'package:lois_bowling_website/bowler.dart';

class DoubleSearchBrain {
  List<DoublePartners> findDoublePartnes(
      List<Bowler> allBowlers, List<Bowler> results) {
    print(results.length);
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

    //we are saying only return those that have 2 bowlers and atleast one of them must be contained in the search results of bowlers
    return doublePartners
        .where((element) =>
            element.bowlers.length > 1 &&
                results.contains(element.bowlers[1]) ||
            results.contains(element.bowlers[0]))
        .toList();
  }
}

class DoublePartners {
  DoublePartners({required this.bowlersid, required this.squad});

  List<dynamic> bowlersid;
  List<Bowler> bowlers = [];
  String squad;

  String returnFirstName() {
    //TODO: known error if you make yourself a double partner
    if (bowlers.isNotEmpty) {
      String firstBowler = bowlers[0].firstName + ' ' + bowlers[0].lastName;
      String secondBowler = bowlers[1].firstName + ' ' + bowlers[1].lastName;

      return firstBowler;
    }

    return '';
  }

  String returnSecondName() {
    //TODO: known error if you make yourself a double partner
    if (bowlers.length > 1) {

      String secondBowler = bowlers[1].firstName + ' ' + bowlers[1].lastName;

      return secondBowler;
    }

    return '';
  }
  int findTeamTotal(){
   int total = 0;
    for(Bowler bowler in bowlers){
      total += bowler.findScoreForSquad(squad);
    }
    return total;
  }
}
