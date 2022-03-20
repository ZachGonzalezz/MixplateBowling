import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';

class BowlersThatDoNotExist {

  List<Bowler> bowlers = [];

  bool isAllGood(){
    //if a bowler average is 0 no Good user needs to add the averge to add them to the database
    for(int i = 0; i < bowlers.length; i++){

      if(bowlers[i].average == 0){
        return false;
      }
    }
    return true;

  }

  Future<List<Bowler>> saveScoresOfExistingBowlers(List<Bowler> bowlersThatExist) async{
List<Bowler> bowlersReturn = [];
      await Future.forEach(bowlersThatExist, (Bowler element)  async {
      await Constants.getTournamentId();
    DocumentReference newDoc = FirebaseFirestore.instance
        .collection(Constants.currentIdForTournament + '/Bowlers').doc(element.uniqueId);
      await newDoc.update({
      'scores' : element.scores,
    });
   
});  

return bowlersReturn;


  }

  Future<List<Bowler>> createBowlers() async{
      List<Bowler> bowlersReturn = [];
      await Future.forEach(bowlers, (Bowler element)  async {
      await Constants.getTournamentId();
    DocumentReference newDoc = FirebaseFirestore.instance
        .collection(Constants.currentIdForTournament + '/Bowlers').doc();
      await newDoc.set({
      'firstName': element.firstName,
      'lastName': element.lastName,
      'average': element.average,
      // 'handicap' : int.parse(handicapController.text),
      'divisions': {},
      'doublePartners': {},
      'id': newDoc.id,
      'isMale': element.isMale,
      'userSidePots': {},
      'usbcNum': '',
      'scores' : element.scores,
      'laneNum': '',
      'uniqueId': '',
      'email': '',
      'phone': '',
      'address': '',
      'paymentType': ''
    });
   
});  

return bowlersReturn;

  }

}