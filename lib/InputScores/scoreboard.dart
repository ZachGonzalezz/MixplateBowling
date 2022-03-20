import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/InputScores/header_tile.dart';
import 'package:loisbowlingwebsite/InputScores/input_score_brain.dart';
import 'package:loisbowlingwebsite/InputScores/input_score_tile.dart';
import 'package:loisbowlingwebsite/InputScores/name_til.dart';
import 'package:loisbowlingwebsite/bowler.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard(
      {Key? key,
      required this.nmOfGames,
      required this.results,
      required this.scoreBrain,
      required this.selectedSquad,
      required this.moveOneDown,
      required this.moveOneUp})
      : super(key: key);

  final int nmOfGames;
  final List<Bowler> results;
  final InputScoreBrain scoreBrain;
  final String selectedSquad;
  final Function(int, int) moveOneUp;
  final Function(int, int) moveOneDown;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: 200 * (nmOfGames + 1),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: nmOfGames + 1, mainAxisExtent: 50),
            //num of games + name column * numbers of Bowlers in results + header row
            itemCount: (nmOfGames + 1) * (results.length + 1),
            itemBuilder: (context, index) {
              //this is the top row
              if (index < nmOfGames + 1) {
                return HeadTile(index: index);
              }
              //this find the current bowler by saying take the index divide it take how many colums there are giving us a decimal number which we round down to stay on current row then minus 1 for the header
              int bowlerIndex = (index / (nmOfGames + 1)).floor() - 1;
              //this is names section of bowler
              if (index % (nmOfGames + 1) == 0) {
                return NameTile(
                    name: results[bowlerIndex].firstName +
                        ' ' +
                        results[bowlerIndex].lastName);
              }

              int gameIndex = index % (nmOfGames + 1);

              return InputScoreTile(
                bowlerInfo: results[bowlerIndex],
                gameNum: gameIndex,
                brain: scoreBrain,
                squad: selectedSquad,
                moveOneDown: moveOneDown,
                moveOneUp: moveOneUp,
                indexOfBowlerInList: bowlerIndex,
              );
            }),
      ),
    );
  }
}
