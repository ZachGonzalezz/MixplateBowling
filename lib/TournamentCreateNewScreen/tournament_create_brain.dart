import 'package:lois_bowling_website/constants.dart';

class TournamentCreateBrain{

static String isGoodtoCreate(String name, DateTime to, DateTime from,){
if(name == ''){
  return 'You must give your tournament a name';
}
if(from.compareTo(to) == -1){
return 'Your tournament ends before it starts this';
}
return '';
}

static void createCourse(String name, DateTime to, DateTime from, List<String> emails){

  Constants.dataBase.collection('Users').doc(Constants.currentSignedInEmail).collection('Tournaments').doc().set({
    'to' : to,
    'from' : from,
    'name' : name,
    'sharedWith' : emails,
     'sidepots' : [{}]
  });
}

}