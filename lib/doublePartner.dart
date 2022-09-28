import 'package:loisbowlingwebsite/bowler.dart';

class DoublePartners {
  DoublePartners({required this.bowlersid, required this.squad});

  List<dynamic> bowlersid;
  List<Bowler> bowlers = [];
  String squad;

  String isNoError(String squad) {
    if (bowlers.length < 2) {
      return 'There is no two people on this doubles team';
    } else if (bowlers[0].divisions[squad + 'Doubles'] !=
        bowlers[1].divisions[squad + 'Doubles']) {
      return bowlers[0].firstName +
          ' has a divsion of ' +
          (bowlers[0].divisions[squad + 'Doubles'] ?? 'None Set') +
          ' while ' +
          bowlers[1].firstName +
          ' has a division of ' +
          (bowlers[1].divisions[squad + 'Doubles'] ?? 'None Set');
    }
    return '';
  }

  String returnFirstName() {
    //TODO: known error if you make yourself a double partner
    if (bowlers.isNotEmpty) {
      String firstBowler = bowlers[0].firstName + ' ' + bowlers[0].lastName;
      // String secondBowler = bowlers[1].firstName + ' ' + bowlers[1].lastName;

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

  int findTeamTotal(int outOf, int percent, List<int> gamesIncluded) {
    int total = 0;
    for (Bowler bowler in bowlers) {
      total +=
          bowler.findScoreForSquad(squad, outOf, percent, true, gamesIncluded);
    }
    return total;
  }

  int findDoublesScratchTotal(int outOf, int percent, List<int> gamesIncluded) {
    int total = 0;
    for (Bowler bowler in bowlers) {
      total +=
          bowler.findScoreForSquad(squad, outOf, percent, false, gamesIncluded);
    }
    return total;
  }

  int findDoublesTotalAverage(int numOfGames) {
    int total = 0;
    for (Bowler bowler in bowlers) {
      total += bowler.average.toInt();
    }
    return total;
  }

  int findDoublesTotalHandicap(int outOf, int percent) {
    int total = 0;
    for (Bowler bowler in bowlers) {
      total += bowler.findHandicap(outOf, percent);
    }
    return total;
  }

  int findDoublesGameTOtal(String squad, int game) {
    int total = 0;
    for (Bowler bowler in bowlers) {
      total += bowler.findScoreForGame(squad, game);
    }
    return total;
  }

  
}
