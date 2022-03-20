import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/InputScores/bowlers_not_exist.dart';
import 'package:loisbowlingwebsite/InputScores/not_exist_tile.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ImageToScores {
  int returnIndexOfElement(String element, int numElement, List<String> arry) {
    List<int> indexFound = [];

    for (int i = 0; i < arry.length; i++) {
      if (arry[i] == element) {
        indexFound.add(i);
      }
    }

    if (indexFound.isEmpty || numElement - 1 > indexFound.length - 1) {
      return -1;
    } else {
      return indexFound[numElement - 1];
    }
  }

  List<Bowler> makeTable(List<String> blocks, List<Bowler> bowlers) {
    List<String> names = findNames(blocks);
    Map<String, List<String>> scores = findScores(blocks);
    return bowlersWithTheirScores(bowlers, names, scores);
  }

  List<String> findNames(List<String> blocks) {
    blocks.remove('Handicap');
    blocks.remove('Name');
    blocks.remove('Average');
    blocks.remove('Scores Recap');
    blocks.remove('ScoresRecap');
    blocks.remove('( Completed Games Only )');
    blocks.remove('Series');
    blocks.remove('Series');

    List<String> names = [];

    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].length > 6 && int.tryParse(blocks[i]) == null) {
        names.add(blocks[i]);
      }
    }

    print(names);
    return names;
  }

  Map<String, List<String>> findScores(List<String> blocks) {
    int startIndex = blocks.indexOf('Game');
    print(blocks);
    int game = 1;
    Map<String, List<String>> scores = {};
    while (blocks.indexOf('Game', startIndex) != -1) {
      int end = startIndex;
      for (int i = startIndex + 1; i < blocks.length; i++) {
        print(blocks[i]);
        if (int.tryParse(blocks[i]) != null) {
          if (game <= 3) {
            if (scores['Game' + game.toString()] == null) {
              scores['Game' + game.toString()] = [];
            }
            scores['Game' + game.toString()]!.add(blocks[i].toString());
          }
        } else {
          game++;
        }
        end++;
      }
      startIndex = end;
      game++;
    }
    print(scores);
    return scores;
  }

  String isGoodToContinue(List<String> blocks) {
    // if(blocks.indexOf('HDCP') == -1){
    //   return "Cant Find HDCP Heading";
    // }
    // if(blocks.indexOf('Lane') == -1){
    //   return "Can't find Lane Heading";
    // }
    // if(blocks.indexOf('Series') == -1){
    //   return "Can't find series heading";
    // }
    // if (blocks.indexOf("Name") == -1) {
    //   return "Can't find name heading";
    // }
    //  if(blocks.indexOf("Average") == -1){
    //   return "Can't find Average heading";
    // }
    return '';
  }

  List<Bowler> bowlersWithTheirScores(List<Bowler> currentBowlers,
      List<String> names, Map<String, List<String>> scores) {
    //this is the list of bowlers that will turn into the scoreboard
    List<Bowler> returnBowlers = [];
    //if this returns and index that means a bowler has been found with that name so they exist
    names.forEach((element) {
      int index = -1;
      for (int i = 0; i < currentBowlers.length; i++) {
        if (currentBowlers[i].firstName + currentBowlers[i].lastName ==
            element) {
          index = names.indexOf(element);
        }
      }
      //if the bowler exists changes the scores
      if (index != -1) {
        bool hasAdded = false;
        //we are looping through all 3 games and finding the score at the index of the bowler name
        for (int i = 1; i <= 3; i++) {
          //we find the index of the bowler in the array we are returning
          int indexOfNewBowler = returnBowlers.indexOf(currentBowlers[index]);

          //if the bowler has not been added to the array we are returning then do so here since the user exists we can use the current bowlers to add that bowler
          if (indexOfNewBowler == -1 && hasAdded == false) {
            returnBowlers.add(currentBowlers[index]);
            indexOfNewBowler = returnBowlers.indexOf(currentBowlers[index]);
            indexOfNewBowler = returnBowlers.length - 1;
            //in case the bowler is the first bowler aka index 0 we have to set the index to 0 because 0 - 1 = -1 would crash
            if (returnBowlers.length == 1) {
              indexOfNewBowler = 0;
            }
            //to avoid duplicates in the array
            hasAdded = true;
          } else if (hasAdded) {
            indexOfNewBowler = returnBowlers.length - 1;
            if (returnBowlers.length == 1) {
              indexOfNewBowler = 0;
            }
          }
          //in case the map is null avoid crashing by adding an empty map
          if (returnBowlers[indexOfNewBowler].scores?['A'] == null) {
            returnBowlers[indexOfNewBowler].scores = {};
            returnBowlers[indexOfNewBowler].scores!['A'] = {};
          }
          //this happens when the camera misses a score and indexs get thrown off this marks it as a 0 to avoid crashing
          if (index > scores['Game' + i.toString()]!.length - 1) {
            returnBowlers[indexOfNewBowler].scores!['A']![i.toString()] = 0;
          }
          //this sets the score for the game according to the sheet
          else {
            returnBowlers[indexOfNewBowler].scores!['A']![i.toString()] =
                int.parse(scores['Game' + i.toString()]![index]);
          }
        }
      }
      //this is so for when the bowler has a name that is not currently on the bowler list in db
      else {
        //bowler does not exist so add a temporary one flagged with does not exist
        returnBowlers.add(Bowler(
            uniqueId: 'test',
            firstName: element,
            lastName: '',
            bowlerDoesExistInDB: false));

        for (int i = 1; i <= 3; i++) {
          int indexOfNewBowler = returnBowlers.length - 1;
          if (returnBowlers[indexOfNewBowler].scores?['A'] == null) {
            returnBowlers[indexOfNewBowler].scores = {};
            returnBowlers[indexOfNewBowler].scores!['A'] = {};
          }
          //avoid crashing if phone misses a number indexes out of line
          if (names.indexOf(element) >
              scores['Game' + i.toString()]!.length - 1) {
            returnBowlers[indexOfNewBowler].scores!['A']![i.toString()] = 0;
          } else {
            returnBowlers[indexOfNewBowler].scores!['A']![i.toString()] =
                int.parse(
                    scores['Game' + i.toString()]![names.indexOf(element)]);
          }
        }
      }
    });
    return returnBowlers;
  }

  void checkIfAllBowlersExists(
      List<Bowler> exist, List<Bowler> notExist, BuildContext context) {
    if (notExist.isNotEmpty) {
      showNotExistPopUp(notExist, exist, context);
    } else {
      BowlersThatDoNotExist bowlerBrain = BowlersThatDoNotExist();
      bowlerBrain.saveScoresOfExistingBowlers(exist);
      successSavePopUp(context);
    }
  }

  void showNotExistPopUp(
      List<Bowler> notExist, List<Bowler> existAlready, BuildContext context) {
    BowlersThatDoNotExist bowlerBrain = BowlersThatDoNotExist();
    bowlerBrain.bowlers = notExist;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  'Some Bowlers on the Printer Sheet Do Not Exist in the Database'),
              content: SizedBox(
                height: 800,
                width: 400,
                child: ListView.builder(
                    itemCount: notExist.length + 1,
                    itemBuilder: (context, index) {
                      if (index == notExist.length) {
                        return TextButton(
                          onPressed: () {
                            //all the averages has been added
                            if (bowlerBrain.isAllGood()) {
                              //creates bowlers that were on sheet but not in db
                              bowlerBrain.createBowlers();
                              //saves the scores of bowlers that already exist
                              bowlerBrain
                                  .saveScoresOfExistingBowlers(existAlready);
                              successSavePopUp(context);
                            } else {
                              //show error popup
                              // print('Not Good');
                              showFailurePopUp(context);
                            }
                          },
                          child: Container(
                              color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              )),
                        );
                      } else {
                        return NotExistTile(
                          bowler: notExist[index],
                          bowlerBrain: bowlerBrain,
                          index: index,
                        );
                      }
                    }),
              ),
            ));
  }

  void showFailurePopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.red[100]!.withOpacity(1.0),
              content: SizedBox(
            
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(MdiIcons.close, color: Colors.red, size: 50),
                      Text(
                          'Everyone needs to have an average and gender selected!',
                          style: TextStyle(fontSize: 20))
                    ],
                  )),
            ));
  }

  void successSavePopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.green[100]!.withOpacity(1.0),
              content: SizedBox(
          
                  width: 400,
                  child: Column(
                       mainAxisSize: MainAxisSize.min,
                    children:  [
                      const Icon(MdiIcons.check, color: Colors.green, size: 50),
                     const Text(
                          'Success Saved Now Check the Website. (May need to click away and come back to score page)',
                          style: TextStyle(fontSize: 20)),

                      TextButton(onPressed: (){
                        Navigator.pushNamed(context, Constants.tournamentHome);
                      }, child: Container(
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10), ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Ok', style: TextStyle(color: Colors.white),),
                        ),
                      ))
                    ],
                  )),
            ), barrierDismissible: false);
  }

  List<String> splitName(String name) {
    List<String> arr = ['', ''];
    int uppercaseLetter = 0;
    for (int i = 0; i < name.length; i++) {
      if (uppercaseLetter < 2) {
        String uppercase = name[i].toUpperCase();
        if (name[i] == uppercase &&
            i < name.length - 2 &&
            uppercaseLetter < 1 &&
            i > 0 &&
            (name[i + 1] != '.' ||
                name[i - 1] != '.' ||
                name[i + 1] != '-' ||
                name[i - 1] != '-')) {
          uppercaseLetter++;
        }
        if (uppercaseLetter == -1) {
          uppercaseLetter = 0;
        }
        arr[uppercaseLetter] += name[i];
      }
    }
    return arr;
  }

  List<Bowler> moveOneDown(List<Bowler> bowlers, int indexStartAt, int game){
    List<Bowler> returnBowlers = bowlers;
    for(int i = returnBowlers.length - 1; i > indexStartAt; i--){
      returnBowlers[i].scores!['A']![game.toString()] = bowlers[i - 1].scores!['A']![game.toString()]!;
    }
    returnBowlers[indexStartAt].scores!['A']![game.toString()] = 0;
    return returnBowlers;

  } 
  //  List<Bowler> moveOneUp(List<Bowler> bowlers, int indexStartAt, int game){
  //   List<Bowler> returnBowlers = bowlers;
  //   for(int i = returnBowlers.length - 2; i > indexStartAt + 1; i--){
  //     returnBowlers[i].scores!['A']![game.toString()] = bowlers[i + 1].scores!['A']![game.toString()]!;
  //   }
  //   returnBowlers[indexStartAt].scores!['A']![game.toString()] = 0;
  //   return returnBowlers;

  // } 
}
