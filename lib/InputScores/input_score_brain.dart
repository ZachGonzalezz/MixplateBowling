
import 'package:lois_bowling_website/bowler.dart';

class InputScoreBrain{

  List<Bowler> bowlers = [];


  void saveScores(){
    for(Bowler bowler in bowlers){
  
      bowler.updateBowlerScores();
    }
  }




}