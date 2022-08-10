import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/AddDoublePartner/partner_brain.dart';
import 'package:loisbowlingwebsite/Brackets/bracket.dart';
import 'package:loisbowlingwebsite/Brackets/bracket_brain.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/pdf_popup.dart';

class BracketScreen extends StatefulWidget {
  const BracketScreen({Key? key}) : super(key: key);

  @override
  _BracketScreenState createState() => _BracketScreenState();
}

class _BracketScreenState extends State<BracketScreen> {
  SettingsBrain brain = SettingsBrain();
  int amountOfSquads = 1;
  int outOf = 200;
  int percent = 100;

  List<String> divisions = ['No Division'];

  String selectedSquad = 'A';
  //this keeps track of which division is selecter per Squad sotred in {"A" : "A Singles (One Division)"}
  Map<String, String> selectedDivisions = {};

  int games = 0;

  //this is the original array from the database
  List<Bowler> bowlers = [];
  //this this the list returned
  List<Bowler> results = [];

  BracketBrain bracketBrain = BracketBrain();

  List<Bracket> brackets = [];

  //this is the list of double partners the user has selected
  Map<String, List<String>> doublePartner = {};
  @override
  void initState() {
    super.initState();
    loadTournamentSettings();
    loadBowlers();
  }

  void loadBowlers() {
    DoublePartner.loadBowlers().then((bowlersFromDB) {
      setState(() {
        bowlers = bowlersFromDB;
        results = bowlersFromDB;

        results.sort((a, b) => a.firstName.compareTo(b.firstName));
      });
      bracketBrain.getBrackets(bowlers).then((value) {
        setState(() {
          brackets = value;
        });
      });
    });
  }

//loads the number of squads in the current tournament (based on name held in local storage)
  void loadTournamentSettings() {
    SettingsBrain().getMainSettings().then((basicSettings) {
      setState(() {
        amountOfSquads = (basicSettings['Squads'] ?? 1).toInt();
        percent = (basicSettings['Handicap Percentage'] ?? 100).toInt();
        outOf = (basicSettings['Handicap Amount'] ?? 200).toInt();
        games = (basicSettings['Games'] ?? 0).toInt();
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
        selected: 'Brackets',
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  child: Text('Save Pdf'),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => PDFGamePopUp(
                                              numOfGames: games,
                                              outOf: outOf,
                                              percent: percent,
                                              brackets: brackets,
                                              division: selectedDivisions[
                                                      selectedSquad] ??
                                                  'No Division',
                                            ));
                                    // PDFBrain().createSinglesPdf(
                                    //     results, games, outOf, percent,
                                    //           ,);
                                  },
                                )),
                            CustomButton(
                                buttonTitle: 'Generate',
                                onClicked: () {
                                  bracketBrain.generateBrackets(
                                      context, bowlers);
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                                buttonTitle: 'Find Winners',
                                onClicked: () {
                                  bracketBrain.findWinnersOfBrackets(
                                      brackets, context, bowlers);
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: ListView.builder(
                                  itemCount: brackets.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Container(
                                        color: Colors.white,
                                        child: ListTile(
                                          tileColor: Colors.white,
                                          title: Text('Bracket: ' +
                                              (brackets[index].id + 1)
                                                  .toString() +
                                              ' ' +
                                              brackets[index].division),
                                          subtitle: Text(
                                              brackets[index].listOutBowlers()),
                                          isThreeLine: true,
                                        ),
                                      ),
                                    );
                                  }),
                            )
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
