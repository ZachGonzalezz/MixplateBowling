import 'package:flutter/material.dart';
import 'package:lois_bowling_website/InputScores/input_score_brain.dart';
import 'package:lois_bowling_website/bowler.dart';

class InputScoreTile extends StatelessWidget {
  InputScoreTile({required this.bowlerInfo, required this.gameNum, required this.brain, required this.squad});

  Bowler bowlerInfo;
  int gameNum;
  String squad;
  InputScoreBrain brain;
  

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: bowlerInfo.scores[squad]?[gameNum.toString()]?.toString());
    return Container(
      decoration: BoxDecoration(
        // color: Color.fromRGBO(78, 239, 238, .5),
        border: Border(
          right: BorderSide(width: 1),
          bottom: BorderSide(width: 1)
        )

      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: TextField(
          keyboardType: TextInputType.phone,
          
          onChanged: (text){
            
            if(int.tryParse(text) != null){
              int num = int.parse(text);
              //find where the bowler is located in the brain class
            int bowlerIndex =   brain.bowlers.indexOf(bowlerInfo);

            Map<String, Map<String, int>> scores = brain.bowlers[bowlerIndex].scores;
            if(scores[squad] == null){
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
            contentPadding: EdgeInsets.symmetric(horizontal:2),
          
          ),

        ),),
      ),
      
    );
  }
}