import 'dart:developer';

import 'package:loisbowlingwebsite/bowler.dart';

class Bracket {
  Bracket({required this.id, required this.bowlerIds, required this.division});

  int id;
  List<String> bowlerIds;
  String division;
  List<Bowler> bowlers = [];
  bool isTie = false;

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

  List<Bowler> findWinnersOfGameOne(bool isHandicap, int outof, int percent) {
    List<Bowler> bowlersReturn = [];

    for (int i = 0; i < bowlers.length; i += 2) {
      double score1Handicap = 0;
      double score2Handicap = 0;
      if (isHandicap) {
        score1Handicap = bowlers[i].findHandicap(outof, percent).toDouble();
        score2Handicap = bowlers[i + 1].findHandicap(outof, percent).toDouble();
      }

      int score1 = (bowlers[i].scores!['A']?[(1).toString()] ?? 0) +
          score1Handicap.toInt();
      int score2 = (bowlers[i + 1].scores!['A']?[(1).toString()] ?? 0) +
          score2Handicap.toInt();
      if (score1 > score2) {
        bowlersReturn.add(bowlers[i]);
      }
   
      else {
        bowlersReturn.add(bowlers[i + 1]);
      }

         if (score1 == score2) {
        isTie = true;
        // bowlersReturn.add(bowlers[i]);
        // bowlersReturn.add(bowlers[i + 1]);
      }
    }
    return bowlersReturn;
  }

  List<Bowler> findWinnersOfGametwo(bool isHandicap, int outof, int percent) {
    List<Bowler> bowlersReturn = [];
    // log(outof.toString());
    //     log(percent.toString());
    //     log(id.toString());
    //     log(isHandicap.toString());

    //     log('\n\n');
    List<Bowler> roundOneWinners =
        findWinnersOfGameOne(isHandicap, outof, percent);

    if (roundOneWinners.length % 2 == 1) {
      //there is a tie uneven amount
      isTie = true;
    }
    for (int i = 0; i < roundOneWinners.length; i += 2) {
      double score1Handicap = 0;
      double score2Handicap = 0;

      if (isHandicap) {
        score1Handicap = roundOneWinners[i].findHandicap(outof, percent).toDouble();
        score2Handicap = roundOneWinners[i + 1].findHandicap(outof, percent).toDouble();
      }

    
      int score1 = (roundOneWinners[i].scores!['A']?[(2).toString()] ?? 0) +
          score1Handicap.toInt();
      int score2 = (roundOneWinners[i + 1].scores!['A']?[(2).toString()] ?? 0) +
          score2Handicap.toInt();

      if (score1 > score2) {
        log('Round two Winner on bracket ${id} ${roundOneWinners[i].firstName} ishandicap is $isHandicap with a score of ${score1}');
        bowlersReturn.add(roundOneWinners[i]);
      } 
     
      else {
        log('Round two Winner on bracket ${id} ${roundOneWinners[i + 1].firstName} ishandicap is $isHandicap with a score of ${score2}');
        bowlersReturn.add(roundOneWinners[i + 1]);
      }

 if(score1 == score2){
           isTie = true;
      }
    }

    return bowlersReturn;
  }

  List<Bowler> findWinnersOfGamethree(bool isHandicap, int outof, int percent) {
    List<Bowler> bowlersReturn = [];

    List<Bowler> roundOneWinners =
        findWinnersOfGametwo(isHandicap, outof, percent);

    // print(roundOneWinners[0].scores!['A']);
    for (int i = 0; i < roundOneWinners.length; i += 2) {
      double score1Handicap = 0;
      double score2Handicap = 0;
      if (isHandicap) {
        score1Handicap = roundOneWinners[i].findHandicap(outof, percent).toDouble();
        score2Handicap = roundOneWinners[i + 1].findHandicap(outof, percent).toDouble();
      }

      int score1 = (roundOneWinners[i].scores!['A']?[(3).toString()] ?? 0) +
          score1Handicap.toInt();
      int score2 = (roundOneWinners[i + 1].scores!['A']?[(3).toString()] ?? 0) +
          score2Handicap.toInt();
      //       log('\n');
      // log(score1.toString() + bowlers[i].firstName);

      // log(score2.toString()+ bowlers[i + 1].firstName);

      // log('\n');
      if (score1 > score2) {
        bowlersReturn.add(roundOneWinners[i]);
      }
     
      else {
        bowlersReturn.add(roundOneWinners[i + 1]);
      }

 if (score1 == score2) {
        isTie = true;
      }
    }

    return bowlersReturn;
  }
}
