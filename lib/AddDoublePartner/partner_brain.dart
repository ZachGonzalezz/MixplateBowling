import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lois_bowling_website/bowler.dart';
import 'package:lois_bowling_website/constants.dart';

class DoublePartner {

 static List<Bowler> filterBowlers({required List<Bowler> bowlers, required String? search}){
    List<Bowler> filtered = [];


    
    //if the search bar is empty send them back to default
    if(search == '' || search == null || search == ' '){
      filtered = bowlers;
    }
    else{
    //search through the names of all the bowlers and see which one contains the search text
    for(Bowler bowler in bowlers){
      //completely lowercases so removes that out of the equation
      if(bowler.firstName.toLowerCase().contains(search.toLowerCase()) || bowler.lastName.toLowerCase().contains(search.toLowerCase())){
        filtered.add(bowler);
      }
    }
    }
    
    //returns results of bowlers
    return filtered;
  }

static  Future<List<Bowler>> loadBowlers() async {
    List<Bowler> bowlers = [];
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Bowlers')
        .get()
        .then((documents) {
      for (DocumentSnapshot doc in documents.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        num average = data['average'] ?? 0;
        num handicap = data['handicap'] ?? 0;
        String firstName = data['firstName'] ?? ' ';
        String lastName = data['lastName'] ?? ' ';
       Map<String, String> divisions = Map<String, String>.from(data['divisions'] ?? {});

        bowlers.add(Bowler(
            uniqueId: doc.id,
            average: average.toDouble(),
            handicap: handicap.toDouble(),
            firstName: firstName,
            lastName: lastName,
            divisions: divisions));
      }
    });

    return bowlers;
  }
}
