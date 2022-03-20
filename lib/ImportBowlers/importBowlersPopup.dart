import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/ImportBowlers/importBowlersBrain.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/TournamentSelectScreen.dart/tournament_select_brain.dart';
import 'package:loisbowlingwebsite/TournamentSelectScreen.dart/tournament_selection_class.dart';
import 'package:loisbowlingwebsite/constants.dart';

class ImportBowlersPopUp extends StatefulWidget {
  const ImportBowlersPopUp({Key? key}) : super(key: key);

  @override
  _ImportBowlersPopUpState createState() => _ImportBowlersPopUpState();
}

class _ImportBowlersPopUpState extends State<ImportBowlersPopUp> {
  List<TournamentSelection> tournamnets = [];
  bool includeScore = false;
  bool includeBowlersTeams = false;
  bool includeBowlersDoublesPartners = false;
  bool includeBowlersDivisions = false;
  bool includeBasicSettings = false;
  bool includeDivisions = false;
  bool includeSidePots = false;
  String selectedTournament = "";
  String email = Constants.currentSignedInEmail;

  @override
  void initState() {
    super.initState();
    loadTournamentsForUser();
  }
  //if shared the email has to be of that who shared it with us so it find the right place in the databse
  void findIfShared(TournamentSelection tourn){
   
    if(tourn.isShared){
      email = tourn.ownerEmail;
    }
    else {
      email = Constants.currentSignedInEmail;
    }
  }

  void loadTournamentsForUser() {
    TournamentSelectBrain().getTournaments().then((value) {
      setState(() {
        tournamnets = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          'Select Which Tournament you would like to import the bowlers from'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 300,
            width: 200,
            child: ListView.builder(
                itemCount: tournamnets.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        selectedTournament = tournamnets[index].id;

                      });
                      findIfShared( tournamnets[index]);
                    },
                    leading: Text(tournamnets[index].name,
                    style: TextStyle(color: selectedTournament == tournamnets[index].id ? Colors.blue : null),),
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Include Scores'),
              SizedBox(width: 20,),
              Checkbox(value: includeScore, onChanged: (newValue){
                setState(() {
                  includeScore = newValue ?? false;
                });
              })
            ],
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Include Bowler\'s Divisions'),
              SizedBox(width: 20,),
              Checkbox(value: includeBowlersDivisions, onChanged: (newValue){
                setState(() {
                  includeBowlersDivisions = newValue ?? false;
                });
              })
            ],
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Include Bowler\'s Teams'),
              SizedBox(width: 20,),
              Checkbox(value: includeBowlersTeams, onChanged: (newValue){
                setState(() {
                  includeBowlersTeams = newValue ?? false;
                });
              })
            ],
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Include Bowler\'s Double Partners'),
              SizedBox(width: 20,),
              Checkbox(value: includeBowlersDoublesPartners, onChanged: (newValue){
                setState(() {
                 includeBowlersDoublesPartners = newValue ?? false;
                });
              })
            ],
          ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Include Basic Settings'),
              SizedBox(width: 20,),
              Checkbox(value: includeBasicSettings, onChanged: (newValue){
                setState(() {
                 includeBasicSettings = newValue ?? false;
                });
              })
            ],
          ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Include Divisions'),
              SizedBox(width: 20,),
              Checkbox(value: includeDivisions, onChanged: (newValue){
                setState(() {
               includeDivisions = newValue ?? false;
                });
              })
            ],
          ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Include Sidepots'),
              SizedBox(width: 20,),
              Checkbox(value: includeSidePots, onChanged: (newValue){
                setState(() {
                 includeSidePots = newValue ?? false;
                });
              })
            ],
          ),
          SizedBox(
            height: 20
          ),

          CustomButton(length: 200, buttonTitle: 'Import Bowlers', onClicked: (){
            
            ImportBrain().importBowlers(selectedTournament, includeScore, includeBowlersDivisions, includeBowlersDoublesPartners, includeBowlersTeams, email);
             ImportBrain().importSettings(selectedTournament, includeBasicSettings, includeDivisions, includeSidePots, email);
            Navigator.pop(context);

          })
        ],
      ),
    );
  }
}
