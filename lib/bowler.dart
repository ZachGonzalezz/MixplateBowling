import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lois_bowling_website/AddDoublePartner/partner_brain.dart';
import 'package:lois_bowling_website/constants.dart';

class Bowler {
  Bowler(
      {this.average = 0.0,
      this.handicap = 0.0,
      this.lastName = '',
      required this.uniqueId,
      this.firstName = '',
      this.divisions = const {},
      this.scores = const {},
      this.doublePartners = const {},
      this.isMale = false});

  double average;
  Map<String, String> divisions;
  String firstName;
  String lastName;
  double handicap;
  String uniqueId;
  Map<String, Map<String, int>> scores;
  Map<String, dynamic> doublePartners;
  bool isMale;
  int bestscore = 0;


  void updateBowlerScores() async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Bowlers')
        .doc(uniqueId)
        .update({'scores': scores});
  }

  void findDoublePartners() async{
 await Constants.getTournamentId();

   List<Bowler> bowlers = await DoublePartner.loadBowlers();

//goes through every bowler
   for(Bowler bowler in bowlers) {

     //takes their doubles partners stored in Map<Squad(String), List<Stirng> (partnerId)>
     Map<String, dynamic> doublePartners = bowler.doublePartners;

    //goes through all the squads of double partners
     doublePartners.forEach((key, value) {
       //each squad can have mutiple double partners so goes through the array
       for(String partnerId in value){
         //if the partner is equal to this bowler id that means that partner is reffering to this bowler
         if(partnerId == uniqueId){
           //if its null than make an empty array so we can add onto it without errors
           if(this.doublePartners[key] == null){
             this.doublePartners[key] = [];
           }
     
        //add their bowler id to our partners list under the squad
         this.doublePartners[key].add(bowler.uniqueId);
         }
       }
       
     });
   }
  }
  

  Future<void> loadBowlerData() async{


 
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Bowlers').doc(uniqueId)
        .get()
        .then((doc) {
      
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        num average = data['average'] ?? 0;
        num handicap = data['handicap'] ?? 0;
        String firstName = data['firstName'] ?? ' ';
        String lastName = data['lastName'] ?? ' ';
        Map<String, String> divisions =
            Map<String, String>.from(data['divisions'] ?? {});
        Map<String, dynamic> scoresDB =
            Map<String, dynamic>.from(data['scores'] ?? {});
          bool isMale = data['IsMale'] ?? false;
          Map<String, dynamic> partners = Map.from(data['doublePartners'] ?? {});

        Map<String, Map<String, int>> scores = {};

        scoresDB.forEach((squad, scoreMap) {
          scores[squad] = {};

          scoreMap.forEach((game, score) {
            scores[squad]![game] = score.toInt();
          });
        });

    
  
            average = average.toDouble();
            handicap = handicap.toDouble();
            firstName = firstName;
            lastName = lastName;
            divisions = divisions;
            scores = scores; 
            isMale = isMale;
            doublePartners = partners;
      
    });

  

  }

  int findScoreForSquad(String squad){
    int total = 0;
    scores[squad]?.forEach((game, score) {
      total += score;
    });

    return total;
  }

  findBestSquadScore(){
    int best = 0;
   scores.forEach((squad, scoreMap) {
     int total = 0;
     scoreMap.forEach((game, score) {
       total += score;
       
     });
     if(total > best){
       best = total;
     }
   });


   bestscore = best;
  }


}
