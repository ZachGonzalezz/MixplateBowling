import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/InputScores/input_score_brain.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/responsive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InputScoreTile extends StatelessWidget {
  InputScoreTile(
      {required this.bowlerInfo,
      required this.gameNum,
      required this.brain,
      required this.squad,
      required this.moveOneDown, 
      required this.moveOneUp,
      required this.indexOfBowlerInList});

  Bowler bowlerInfo;
  int gameNum;
  String squad;
  InputScoreBrain brain;
   final Function(int, int) moveOneUp;
  final Function(int, int) moveOneDown;
  int indexOfBowlerInList;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(
        text: bowlerInfo.scores![squad]?[gameNum.toString()]?.toString());
    return Container(
      decoration: BoxDecoration(
          // color: Color.fromRGBO(78, 239, 238, .5),
          border: Border(
              right: BorderSide(width: 1), bottom: BorderSide(width: 1))),
      child: SizedBox(
        height: 100,
        width: 180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SizedBox(
                  height: 100,
                  width: Responsive.isMobileOs(context) ? 120 : 180,
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    onChanged: (text) {
                      if (int.tryParse(text) != null) {
                        int num = int.parse(text);
                        //find where the bowler is located in the brain class
                        int bowlerIndex = brain.bowlers.indexOf(bowlerInfo);

                        Map<String, Map<String, int>> scores =
                            brain.bowlers[bowlerIndex].scores!;
                        if (scores[squad] == null) {
                          scores[squad] = {};
                        }
                        scores[squad]![gameNum.toString()] = num;
                        brain.bowlers[bowlerIndex].scores = scores;
                      }
                    },
                    controller: controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              ),
            ),
            Responsive.isMobileOs(context) ? SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              // GestureDetector(onTap: (){
              //   showDialog(context: context, builder: (context) => AlertDialog(
              //     title: Text('Do you want to shift all the scores for game' + gameNum.toString() + ' up 1. It will shift the current box you clicked '),
              //     content: TextButton(onPressed: (){
              //     moveOneUp(indexOfBowlerInList, gameNum);
              //     }, child: Container(
              //       color: Colors.blue,
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text('Confrim'),
              //       )
              //     )),
              //   ));
              // }, child: Icon(MdiIcons.arrowUp, size: 21)),
                  GestureDetector(onTap: (){
                    showDialog(context: context, builder: (context) => AlertDialog(
                  title: Text('Do you want to shift all the scores for game' + gameNum.toString() + ' down 1. It will shift the current box you clicked '),
                  content: TextButton(onPressed: (){
                  moveOneDown(indexOfBowlerInList, gameNum);
                  }, child: Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Confrim'),
                    )
                  )),
                ));
                  }, child: Icon(MdiIcons.arrowDown, size: 21)),
                ],
              ),
            ) : SizedBox()

          ],
        ),
      ),
    );
  }
}
