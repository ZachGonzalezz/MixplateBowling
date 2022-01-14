import 'package:flutter/material.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';
import 'package:lois_bowling_website/TeamSearch/team_scores.dart';
import 'package:lois_bowling_website/TeamsCreate/team_brain.dart';
import 'package:lois_bowling_website/TeamsCreate/team_create_screen.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:lois_bowling_website/pdf.dart';
import 'package:lois_bowling_website/team.dart';
import 'package:lois_bowling_website/universal_ui.dart/basic_screen_layout.dart';
import 'package:lois_bowling_website/universal_ui.dart/division_picker.dart';
import 'package:lois_bowling_website/universal_ui.dart/pdf_popup.dart';
import 'package:lois_bowling_website/universal_ui.dart/search_bar.dart';
import 'package:lois_bowling_website/universal_ui.dart/squad_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TeamSearchScreen extends StatefulWidget {
  TeamSearchScreen({Key? key, this.isCreatingNewBowler = true})
      : super(key: key);

  bool isCreatingNewBowler;

  @override
  State<TeamSearchScreen> createState() => _TeamSearchScreenState();
}

class _TeamSearchScreenState extends State<TeamSearchScreen> {
  SettingsBrain brain = SettingsBrain();
  int amountOfSquads = 1;
  String teamsize = '';
  int outOf = 200;
  int percent = 100;
  int game = 1;

  List<String> divisions = ['No Division'];

  String selectedSquad = 'A';
  //this keeps track of which division is selecter per Squad sotred in {"A" : "A Singles (One Division)"}
  Map<String, String> selectedDivisions = {};

  //this is the original array from the database
  List<Team> bowlers = [];
  //this this the list returned
  List<Team> results = [];

  //this is the list of double partners the user has selected
  Map<String, List<String>> doublePartner = {};
  @override
  void initState() {
    super.initState();
    loadTournamentSettings();
    loadTeams();
  }

//loads the number of squads in the current tournament (based on name held in local storage)
  void loadTournamentSettings() {
    SettingsBrain().getMainSettings().then((basicSettings) {
      setState(() {
        amountOfSquads = (basicSettings['Squads'] ?? 1).toInt();
        teamsize = (basicSettings['Team Size'] ?? 1).toInt().toString();
        percent = (basicSettings['Handicap Percentage'] ?? 100).toInt();
        outOf = (basicSettings['Handicapt Amount'] ?? 200).toInt();
        game = (basicSettings['Games'] ?? 1).toInt();
      });
    });
    //loads all the divisions and squads
    SettingsBrain().loadDivisions().then((divisionFromDB) {
      setState(() {
        divisions = divisionFromDB;
      });
    });
  }

  void loadTeams() {
    TeamBrain().loadTeamsFromDb().then((teamsDb) {
      setState(() {
        bowlers = teamsDb;
      });
      bowlers.forEach((element) {
        element.loadBowlers().then((value) {
          setState(() {});
          results = TeamBrain.filterTeams(
              teams: bowlers,
              search: '',
              outOf: outOf,
              percent: percent,
              squad: 'A');
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLayout(
        selected: widget.isCreatingNewBowler ? 'Create Bowler' : 'Teams',
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
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(MdiIcons.chevronLeft)),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  child: Text('Save Pdf'),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => PDFGamePopUp(
                                              numOfGames: game,
                                              outOf: outOf,
                                              percent: percent,
                                              division: selectedDivisions[
                                                      selectedSquad] ??
                                                  'No Division',
                                              teams: results,
                                            ));
                                  },
                                )),
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                child: Text('Make a Team'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Constants.teamCreate);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // this picks which division the user is in
                                DivisionPicker(
                                  mustContain: 'Team',
                                  division: divisions,
                                  selectedSquad: selectedSquad,
                                  selectedDivision: selectedDivisions,
                                  onDivisionChange: (newDivision) {
                                    selectedDivisions[selectedSquad] =
                                        newDivision;
                                    setState(() {
                                      results = TeamBrain.filterTeams(
                                          teams: bowlers,
                                          search: '',
                                          outOf: outOf,
                                          percent: percent,
                                          squad: selectedSquad,
                                          division: selectedDivisions[
                                                  selectedSquad] ??
                                              'A');
                                    });
                                  },
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
                                        results = TeamBrain.filterTeams(
                                            teams: bowlers,
                                            search: '',
                                            outOf: outOf,
                                            percent: percent,
                                            squad: selectedSquad,
                                            division: selectedDivisions[
                                                    selectedSquad] ??
                                                'A');
                                      });
                                    }),
                              ],
                            ),
                            SizedBox(height: 30),
                            CustomSearchBar(
                                backTo: Constants.createNewBowler,
                                onChange: (text) {
                                  //when user types in search bar automatically changes who pops up
                                  setState(() {
                                    results = TeamBrain.filterTeams(
                                        teams: bowlers,
                                        search: text,
                                        outOf: outOf,
                                        percent: percent,
                                        squad: selectedSquad,
                                        division:
                                            selectedDivisions[selectedSquad] ??
                                                'No Divsion');
                                  });
                                }),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                  itemCount: results.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        if (widget.isCreatingNewBowler) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeamCreateScreen(
                                                        teamData:
                                                            results[index],
                                                      )));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeamScoreScreen(
                                                        team: results[index],
                                                      )));
                                        }
                                      },
                                      leading: SizedBox(
                                        width: 500,
                                        child: Row(
                                          children: [
                                            Text(
                                                results[index].name +
                                                    '     ' +
                                                    results[index]
                                                        .bowlerIDs
                                                        .values
                                                        .toList()
                                                        .length
                                                        .toString() +
                                                    '/' +
                                                    teamsize,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                )),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(results[index].division),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(results[index].squad),
                                            SizedBox(
                                              width: 20,
                                            ),

                                            //this is the score for the team
                                            widget.isCreatingNewBowler == false
                                                ? Text(results[index]
                                                    .findTeamTotal(outOf,
                                                        percent, []).toString())
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            MdiIcons.chevronRight,
                                            color:
                                                (doublePartner[selectedSquad] ??
                                                            [])
                                                        .contains(
                                                            results[index].id)
                                                    ? Colors.blue
                                                    : null,
                                          )),
                                    );
                                  }),
                            ),
                            Center(
                              child: CustomButton(
                                buttonTitle: 'Finalize',
                                length: 300,
                                onClicked: () {},
                              ),
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
