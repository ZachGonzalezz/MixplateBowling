import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/InputScores/input_score_brain.dart';
import 'package:loisbowlingwebsite/InputScores/scoreboard.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/squad_picker.dart';

class SingleScoreScreen extends StatefulWidget {
  SingleScoreScreen({Key? key, required this.bowler}) : super(key: key);

  Bowler bowler;
  @override
  State<SingleScoreScreen> createState() => _SingleScoreScreenState();
}

class _SingleScoreScreenState extends State<SingleScoreScreen> {
  SettingsBrain brain = SettingsBrain();
  InputScoreBrain scoreBrain = InputScoreBrain();
  int amountOfSquads = 1;
  int numOfGames = 1;

  List<String> divisions = ['  No Division'];

  String selectedSquad = 'A';
  //this keeps track of which division is selecter per Squad sotred in {"A" : "A Singles (One Division)"}
  Map<String, String> selectedDivisions = {};

  //this is the original array from the database
  List<Bowler> bowlers = [];
  //this this the list returned
  List<Bowler> results = [];

  //this is the list of double partners the user has selected
  List<Bowler> doublePartner = [];

  //stores the team members on the teams {0 Bowler('Zach' 'Gonzalez' 'hudahiu978ye9712' '195' '35')};
  Map<String, Bowler> teamMates = {};

  TextEditingController teamName = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadTournamentSettings();
    scoreBrain.bowlers = [widget.bowler];
  }

//loads the number of squads in the current tournament (based on name held in local storage)
  void loadTournamentSettings() {
    SettingsBrain().getMainSettings().then((basicSettings) {
      setState(() {
        amountOfSquads = (basicSettings['Squads'] ?? 1).toInt();
        numOfGames = (basicSettings['Games'] ?? 1).toInt();
      });
    });
    //loads all the divisions and squads
    SettingsBrain().loadDivisions().then((divisionFromDB) {
      setState(() {
        divisions = divisionFromDB;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLayout(
        selected: 'Singles',
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.15,
                  MediaQuery.of(context).size.height * 0.15,
                  MediaQuery.of(context).size.width * 0.15,
                  0),
              child: Container(
                decoration: BoxDecoration(
                    color: Constants.lightBlue,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            BackButton(),
                            SizedBox(height: 30),
                            //these are the textfields to enter infromation controllers are held in create brain to be used to save in DB
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //this picks which division the user is in

                                SizedBox(
                                  width: 30,
                                ),
                                SquadPicker(
                                    brain: null,
                                    numberOfSquads: amountOfSquads,
                                    //when picker is change changes the selected squad whichd determines which division are shown
                                    chnageSquads: (squad) {
                                      setState(() {
                                        selectedSquad = squad;
                                      });
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ScoreBoard(
                                nmOfGames: numOfGames,
                                results: [widget.bowler],
                                scoreBrain: scoreBrain,
                                selectedSquad: selectedSquad,
                                 moveOneDown: (index, game){

                                },
                                moveOneUp: (index, game){
                                  
                                },),

                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: CustomButton(
                                buttonTitle: 'Update Info',
                                length: 300,
                                onClicked: () {
                                  scoreBrain.bowlers = [widget.bowler];

                                  scoreBrain.saveScores();
                                  Navigator.popAndPushNamed(context, Constants.searchSingles);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ])),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
