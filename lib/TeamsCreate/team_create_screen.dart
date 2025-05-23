import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:loisbowlingwebsite/AddDoublePartner/partner_brain.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/TeamsCreate/team_brain.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/team.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_popup.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/division_picker.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/squad_picker.dart';

class TeamCreateScreen extends StatefulWidget {
  TeamCreateScreen({Key? key, this.teamData}) : super(key: key);

  Team? teamData;
  @override
  State<TeamCreateScreen> createState() => _TeamCreateScreenState();
}

class _TeamCreateScreenState extends State<TeamCreateScreen> {
  SettingsBrain brain = SettingsBrain();
  int amountOfSquads = 1;
  int teamSize = 1;
  int outOf = 200;
  int percent = 100;

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
    loadBowlers();
    if (widget.teamData != null) {
      widget.teamData!.loadBowlers().then((value) {
        setState(() {
          teamMates = widget.teamData!.bowlers;
        });
      });
    }
  }

  void loadBowlers() {
    DoublePartner.loadBowlers().then((bowlersFromDB) {
      setState(() {
        bowlers = bowlersFromDB;
        results = bowlersFromDB;
      });
    });
  }

//loads the number of squads in the current tournament (based on name held in local storage)
  void loadTournamentSettings() {
    SettingsBrain().getMainSettings().then((basicSettings) {
      setState(() {
        amountOfSquads = (basicSettings['Squads'] ?? 1).toInt();
        teamSize = (basicSettings['Team Size'] ?? 1).toInt();
        percent = (basicSettings['Handicap Percentage'] ?? 100).toInt();
        outOf = (basicSettings['Handicap Amount'] ?? 200).toInt();
        if (widget.teamData != null) {
          teamName.text = widget.teamData!.name;
          selectedDivisions[widget.teamData!.squad] = widget.teamData!.division;
        }
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
    print("Sanity Check");
    return Scaffold(
      body: ScreenLayout(
        selected: 'Create Bowler',
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
                            SizedBox(height: 30),
                            //these are the textfields to enter infromation controllers are held in create brain to be used to save in DB
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //this picks which division the user is in
                                DivisionPicker(
                                  division: divisions,
                                  selectedSquad: selectedSquad,
                                  selectedDivision: selectedDivisions,
                                  onDivisionChange: (newDivision) {
                                    selectedDivisions[selectedSquad] =
                                        newDivision;
                                  },
                                  mustContain: 'Team',
                                ),
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
                              height: 30,
                            ),
                            SizedBox(
                              height: teamSize * 75,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ListView.builder(
                                itemCount: teamSize,
                                itemBuilder: (context, index) {
                                  print("Index: " + index.toString());
                                  final TextEditingController controller =
                                      TextEditingController(
                                    text: TeamBrain().displayName(
                                      bowler: teamMates[index.toString()],
                                    ),
                                  );

                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text((index + 1).toString()),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.22,
                                              child: TypeAheadField<Bowler>(
                                                
                                                suggestionsCallback: (text) {
                                                  return DoublePartner
                                                      .filterBowlers(
                                                    bowlers: bowlers,
                                                    search: text,
                                                    outOf: outOf,
                                                    percent: percent,
                                                  );
                                                },
                                                itemBuilder: (context, bowler) {
                                                  return ListTile(
                                                      title: Text(
                                                          bowler.firstName +
                                                              ' ' +
                                                              bowler.lastName));
                                                },
                                                onSuggestionSelected:
                                                    (bowlerSelected) {
                                                  log("Test");
                                                  print("Bowlers Selected" +
                                                      bowlerSelected
                                                          .toString());
                                                  try {
                                                    setState(() {
                                                      teamMates[index
                                                              .toString()] =
                                                          bowlerSelected;
                                                      if (widget.teamData !=
                                                          null) {
                                                        widget.teamData!
                                                                    .bowlerIDs[
                                                                index
                                                                    .toString()] =
                                                            bowlerSelected
                                                                .uniqueId;
                                                      }
                                                      controller
                                                          .text = bowlerSelected
                                                              .firstName +
                                                          ' ' +
                                                          bowlerSelected
                                                              .lastName; // Update the text field
                                                    });
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                },
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  controller: controller,
                                                  decoration: InputDecoration(
                                                    hintText: 'Team Member ' +
                                                        (index + 1).toString(),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: TextField(
                                  controller: teamName,
                                  decoration: InputDecoration(
                                      hintText: 'Team Name',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      fillColor: Colors.white,
                                      filled: true),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: CustomButton(
                                buttonTitle: widget.teamData == null
                                    ? 'Save Team'
                                    : 'Update Info',
                                length: 300,
                                onClicked: () {
                                  if (teamName.text != '') {
                                    if (widget.teamData == null) {
                                      TeamBrain().saveNewTeam(
                                          name: teamName.text,
                                          teamMembers: teamMates,
                                          division: selectedDivisions[
                                                  selectedSquad] ??
                                              '',
                                          squad: selectedSquad);
                                      Navigator.pushNamed(
                                          context, Constants.teamSearch);
                                    } else {
                                      TeamBrain().updateATeam(
                                          name: teamName.text,
                                          teamMembers: teamMates,
                                          division: selectedDivisions[
                                                  selectedSquad] ??
                                              '',
                                          squad: selectedSquad,
                                          id: widget.teamData!.id);
                                      Navigator.pushNamed(
                                          context, Constants.teamSearch);
                                      // Navigator.pop(
                                      //     context,
                                      //     Team(
                                      //       id: widget.teamData!.id,
                                      //       name: teamName.text,
                                      //       bowlers: teamMates,
                                      //       bowlerIDs:
                                      //           widget.teamData!.bowlerIDs,
                                      //       division: selectedDivisions[
                                      //               selectedSquad] ??
                                      //           '',
                                      //       squad: selectedSquad,
                                      //     ));
                                    }
                                  } else {
                                    BasicPopUp().showBasicDialog(context,
                                        'Ensure that the team has a name');
                                  }
                                },
                              ),
                            ),

                            SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: CustomButton(
                                  buttonTitle: 'Delete',
                                  onClicked: () async {
                                    await TeamBrain()
                                        .deleteTeam(widget.teamData?.id ?? '');
                                    Navigator.pushNamed(
                                        context, Constants.teamSearch);
                                  }),
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
