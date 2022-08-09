import 'package:loisbowlingwebsite/bowler.dart';

class Bracket {
  Bracket({required this.id, required this.bowlerIds, required this.division});

  int id;
  List<String> bowlerIds;
  String division;
  List<Bowler> bowlers = [];

  String listOutBowlers(){

    String returnString = '';

    int index = 0;
    for(Bowler bowler in bowlers){
      returnString += bowler.firstName + ' ' + bowler.lastName + ',   ';
      if(index == 3){
        returnString + '\n';
      }
      index++;
    }

    return returnString;

  }
}
