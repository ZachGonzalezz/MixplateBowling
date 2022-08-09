import 'package:loisbowlingwebsite/bowler.dart';

class Bracket {
  Bracket({required this.id, required this.bowlerIds, required this.division});

  int id;
  List<String> bowlerIds;
  String division;
  List<Bowler> bowlers = [];

  String listOutBowlers() {
    String returnString = '';

    int index = 0;
    for (Bowler bowler in bowlers) {
      returnString += bowler.firstName + ' ' + bowler.lastName + ',   ';
      if (index == 3) {
        returnString + '\n';
      }
      index++;
    }

    return returnString;
  }

  List<Bowler> findWinnersOfGameOne() {
    List<Bowler> bowlersReturn = [];

    for (int i = 0; i < bowlers.length; i += 2) {
      int score1 = bowlers[i].scores!['A']?[(1).toString()] ?? 0;
      int score2 = bowlers[i + 1].scores!['A']?[(1).toString()] ?? 0;
      if (score1 > score2) {
        bowlersReturn.add(bowlers[i]);
      } else {
        bowlersReturn.add(bowlers[i + 1]);
      }
    }
    return bowlersReturn;
  }

  List<Bowler> findWinnersOfGametwo() {
    List<Bowler> bowlersReturn = [];

    List<Bowler> roundOneWinners = findWinnersOfGameOne();
    for (int i = 0; i < roundOneWinners.length; i += 2) {
      int score1 = roundOneWinners[i].scores!['A']?[(2).toString()] ?? 0;
      int score2 = roundOneWinners[i + 1].scores!['A']?[(2).toString()] ?? 0;
      if (score1 > score2) {
        bowlersReturn.add(roundOneWinners[i]);
      } else {
        bowlersReturn.add(roundOneWinners[i + 1]);
      }
    }

    return bowlersReturn;
  }

  List<Bowler> findWinnersOfGamethree() {
    List<Bowler> bowlersReturn = [];

    List<Bowler> roundOneWinners = findWinnersOfGametwo();
    print(roundOneWinners[0].scores!['A']);
    for (int i = 0; i < roundOneWinners.length; i += 2) {
      int score1 = roundOneWinners[i].scores!['A']?[(3).toString()] ?? 0;
      int score2 = roundOneWinners[i + 1].scores!['A']?[(3).toString()] ?? 0;
      if (score1 > score2) {
        bowlersReturn.add(roundOneWinners[i]);
      } else {
        bowlersReturn.add(roundOneWinners[i + 1]);
      }
    }

    return bowlersReturn;
  }
}
