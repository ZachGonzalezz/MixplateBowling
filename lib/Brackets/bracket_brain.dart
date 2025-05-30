import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/Brackets/bracket.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_popup.dart';

class BracketBrain {
  int bracketSize = 8;
  int maxBracket = 100;

// Find the winners of the brackets
// Pay out 25 for first place and 10 for second place
// Determine the winners of the brackets on 3rd game
  findWinnersOfBrackets(List<Bracket> brackets, BuildContext context,
      List<Bowler> bowlersMain, int outof, int percent) {
    String winnersString = '';

    brackets.sort((a, b) => a.division.compareTo(b.division));
    for (Bracket bracket in brackets) {
      winnersString += '\n';
      winnersString += '\n';
      List<Bowler> bowlers = bracket.findWinnersOfGametwo(
          bracket.division == 'Handicap', outof, percent);
      bowlers.sort((a, b) =>
          (a.scores?['A']?['3'] ?? 0).compareTo((b.scores!['A']?['3'] ?? 0)));
      int place = 1;
      for (Bowler bowler in bowlers.reversed.toList()) {
        winnersString += 'Bracket ${bracket.id} ${bracket.division} Division\n';
        if (place == 1) {
          int indexOfBowler = bowlersMain.indexOf(bowler);
          bowlersMain[indexOfBowler].bracketWinnings += 25;

          winnersString +=
              bowler.firstName + ' ' + bowler.lastName + ': \$25\n';
        } else if (place == 2) {
          int indexOfBowler = bowlersMain.indexOf(bowler);
          bowlersMain[indexOfBowler].bracketWinnings += 10;
          winnersString +=
              bowler.firstName + ' ' + bowler.lastName + ': \$10\n';
        } else if (place == 3) {}
        place += 1;
      }
      winnersString += '\n';
    }

    winnersString += '\n';

    winnersString += '\n';
    winnersString += '\n';

    winnersString += 'Totals:';
    winnersString += '\n';
    winnersString += '\n';

    //exclude 0 from the list
    bowlersMain =
        bowlersMain.where((bowler) => bowler.bracketWinnings != 0).toList();

    for (Bowler bowler in bowlersMain) {
      winnersString += bowler.firstName +
          ' ' +
          bowler.lastName +
          ':' +
          (bowler.bracketWinnings / 2).toString() +
          '\n';
    }

    showDialog(
        context: context,
        builder: (context) {
          return BasicPopUp(
            text: winnersString,
          );
        });
  }

// Generate the brackets
// Sort the bowlers by the number of brackets they are in
// Shuffle the bowlers
// For each bowler, add them to a bracket
// If the bracket is full, add them to the next bracket
// If there is no bracket for them, create a new bracket
// Save the brackets to the database
  List<Bracket> generateBrackets(BuildContext context, List<Bowler> bowlers) {
    bowlers.sort((a, b) => (a.numOfHandicapBrackets + a.numOfScratchBrackets)
        .compareTo(b.numOfHandicapBrackets + a.numOfScratchBrackets));

    List<Bracket> brackets = [];
    for (int i = 0; i < 100; i++) {
      // bowlers.shuffle();
      for (Bowler bowler in bowlers.reversed.toList()) {
        // print(i);
        if (bowler.numOfHandicapBrackets > 0) {
          int addToBracketNum =
              findIndexOfBracketToAdd(brackets, bowler, 'Handicap');
          //if it return -1 no brackets match add a new one
          if (addToBracketNum == -1) {
            brackets.add(Bracket(
                id: brackets.length + 1,
                bowlerIds: [bowler.uniqueId],
                division: 'Handicap'));
            brackets.last.bowlers.add(bowler);
          } else {
            brackets[addToBracketNum].bowlerIds.add(bowler.uniqueId);
            brackets[addToBracketNum].bowlers.add(bowler);
          }
          bowler.numOfHandicapBrackets -= 1;
        }
        if (bowler.numOfScratchBrackets > 0) {
          int addToBracketNum =
              findIndexOfBracketToAdd(brackets, bowler, 'Scratch');
          if (addToBracketNum == -1) {
            brackets.add(Bracket(
                id: brackets.length + 1,
                bowlerIds: [bowler.uniqueId],
                division: 'Scratch'));
            brackets.last.bowlers.add(bowler);
          } else {
            brackets[addToBracketNum].bowlerIds.add(bowler.uniqueId);
            brackets[addToBracketNum].bowlers.add(bowler);
          }
          bowler.numOfScratchBrackets -= 1;
        }
      }
    }

    String result = '';
    result = checkBrackets(brackets);
    if (result != '') {
      showDialog(
          context: context,
          builder: (context) {
            return BasicPopUp(
              text: result,
            );
          });
    } else {
      saveBracketsDb(brackets);
      showDialog(
          context: context,
          builder: (context) {
            return BasicPopUp(
              text: successMetrics(brackets),
            );
          });
    }
    return brackets;
  }

// Delete the old brackets
// Get the current tournament id
// Get the brackets from the database
// Delete the brackets
  Future<void> deleteOldBrackets(List<Bracket> brackets) async {
    await Constants.getTournamentId();

    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection =
        instance.collection(Constants.currentIdForTournament + '/Brackets');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

// Save the brackets to the database
  void saveBracketsDb(List<Bracket> brackets) async {
    //delete old one to clear brackets
    await deleteOldBrackets(brackets);
    await Constants.getTournamentId();
    //saves new one to db
    int index = 0;
    for (Bracket bracket in brackets) {
      saveBracketToDb(bracket, index);
      index++;
    }
  }

  // Save the bracket to the database
  void saveBracketToDb(Bracket bracket, int index) {
    final instance = FirebaseFirestore.instance;
    //this randomizes people in the bracket
    bracket.bowlerIds.shuffle();
    instance
        .collection(Constants.currentIdForTournament + '/Brackets')
        .doc(index.toString())
        .set({
      'id': index,
      'bowlerIds': bracket.bowlerIds,
      'division': bracket.division
    });
  }

  // Get the brackets from the database
  Future<List<Bracket>> getBrackets(List<Bowler> bowlers) async {
    await Constants.getTournamentId();
    final instance = FirebaseFirestore.instance;

    List<Bracket> brackets = [];

    //load brackets from firebase
    await instance
        .collection(Constants.currentIdForTournament + '/Brackets')
        .get()
        .then((documents) {
      for (var doc in documents.docs) {
        Map<String, dynamic> data = doc.data();
        Bracket newBracket = Bracket(
            id: int.parse(doc.id),
            bowlerIds: List.from(data['bowlerIds'] ?? []),
            division: data['division']);
        brackets.add(newBracket);
      }
    });

    //add Bowler Object to brackets
    for (Bracket bracket in brackets) {
      for (String bowlerId in bracket.bowlerIds) {
        for (Bowler bowler in bowlers) {
          if (bowler.uniqueId == bowlerId) {
            bracket.bowlers.add(bowler);
          }
        }
      }
    }
    return brackets;
  }

// Find the index of the bracket to add the bowler to
// If the bowler is not in the bracket and the bracket is not full, return the index
// If the bowler is in the bracket, return -1
  int findIndexOfBracketToAdd(
      List<Bracket> brackets, Bowler bowler, String division) {
    int index = 0;
    for (Bracket bracket in brackets) {
      if (bracket.bowlerIds.contains(bowler.uniqueId) == false &&
          bracket.division == division &&
          bracket.bowlerIds.length < bracketSize) {
        return index;
      }
      index++;
    }
    return -1;
  }

// Generate the success metrics
// Find the number of brackets made
// Find the number of handicap brackets made
// Find the number of scratch brackets made
// Find the total money from brackets
// Find the total money from handicap brackets
// Find the total money from scratch brackets
  String successMetrics(List<Bracket> brackets) {
    String metrics = '\nSuccess\n\n\n';

    int handicapBrackets = brackets
        .where((element) => element.division == 'Handicap')
        .toList()
        .length;
    int scratchBrackets = brackets
        .where((element) => element.division == 'Scratch')
        .toList()
        .length;

    metrics += 'Total Brackets Made: ${brackets.length}\n';
    metrics += 'Total Handicap Brackets: $handicapBrackets\n';
    metrics += 'Total Scratch Brackets: $scratchBrackets\n';
    metrics += 'Total Money From Brackets: \$${brackets.length * 35}\n';
    metrics += 'Total Money From HCP Brackets:  \$${handicapBrackets * 35}\n';
    metrics += 'Total Money From SCT Brackets:  \$${scratchBrackets * 35}\n';
    metrics += 'Your Cut:  \$${scratchBrackets * 5}\n';

    return metrics;
  }

  String checkBrackets(List<Bracket> brackets) {
    int totalMissingHandicap = 0;
    int totalMissingScratch = 0;
    List<Bracket> missingBrackets = [];
    for (Bracket bracket in brackets) {
      if (bracket.bowlerIds.length < bracketSize) {
        int missingAmount = bracketSize - bracket.bowlerIds.length;
        missingBrackets.add(bracket);
        if (bracket.division == 'Scratch') {
          totalMissingScratch += missingAmount;
        } else {
          totalMissingHandicap += missingAmount;
        }
      }
    }

    String helpful = '';

    for (Bracket bracket in missingBrackets) {
      helpful += '\n';
      for (Bowler bowler in bracket.bowlers) {
        helpful += bowler.firstName + ' ' + bowler.lastName + '\n';
      }
      helpful += '\n';
      helpful += 'Division: ${bracket.division}\n';
      helpful += 'Missing: ${bracketSize - bracket.bowlerIds.length}';
      helpful += '\n\n';
    }
    if (totalMissingScratch != 0 || totalMissingHandicap != 0) {
      return 'You Are Missing $totalMissingScratch Scratch Bowlers and $totalMissingHandicap Handicap Bowlers\n${brackets.length} Total Brackets Made \n $helpful';
    }
    return '';
  }
}
