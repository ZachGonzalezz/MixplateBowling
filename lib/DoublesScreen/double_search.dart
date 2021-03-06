import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/AddDoublePartner/partner_brain.dart';
import 'package:loisbowlingwebsite/DoublesScreen/double_indivisual.dart';
import 'package:loisbowlingwebsite/DoublesScreen/double_search_brain.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/doublePartner.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_popup.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/division_picker.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/pdf_popup.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/search_bar.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/squad_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchDoublesScreen extends StatefulWidget {
  const SearchDoublesScreen({Key? key}) : super(key: key);

  @override
  _SearchDoublesScreenState createState() => _SearchDoublesScreenState();
}

class _SearchDoublesScreenState extends State<SearchDoublesScreen> {
  SettingsBrain brain = SettingsBrain();
  int amountOfSquads = 1;

  int outOf = 200;
  int percent = 100;
  int game = 1;
  List<String> divisions = ['No Division'];

  String selectedSquad = 'A';
  //this keeps track of which division is selecter per Squad sotred in {"A" : "A Singles (One Division)"}
  Map<String, String> selectedDivisions = {};

  //this is the original array from the database
  List<Bowler> bowlers = [];
  //this this the list returned
  List<Bowler> results = [];

  //this this the list returned
  List<DoublePartners> resultsPartners = [];

  int totalTeams = 0;

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
        resultsPartners =
            DoubleSearchBrain().findDoublePartnes(bowlers, results, null, null);
        resultsPartners.sort((a, b) => b.findTeamTotal(
            outOf, percent, []).compareTo(a.findTeamTotal(outOf, percent, [])));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLayout(
        selected: 'Doubles',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                                   Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                      child: Text(resultsPartners.length.toString() + ' Total Doubles', style: TextStyle(fontSize: 15,)),
                                      onPressed: () {
                                        
                                      },
                                    )),

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
                                                  doubles: resultsPartners,
                                                ));
                                      },
                                    )),
                              ],
                            ),
                            // Padding(padding: EdgeInsets.all(8),
                            // child: IconButton(onPressed: (){
                            //   Navigator.pop(context);
                            // }, icon: Icon(MdiIcons.chevronLeft)),),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //this picks which division the user is in
                                DivisionPicker(
                                  mustContain: 'Doubles',
                                  division: divisions,
                                  selectedSquad: selectedSquad,
                                  selectedDivision: selectedDivisions,
                                  onDivisionChange: (newDivision) {
                                    selectedDivisions[selectedSquad] =
                                        newDivision;
                                    setState(() {
                                      results = DoublePartner.filterBowlers(
                                          bowlers: bowlers,
                                          search: '',
                                          outOf: outOf,
                                          percent: percent);
                                      resultsPartners = DoubleSearchBrain()
                                          .findDoublePartnes(
                                              bowlers,
                                              results,
                                              selectedSquad,
                                              selectedDivisions[selectedSquad]);
                                      resultsPartners.sort((a, b) => b
                                          .findTeamTotal(outOf, percent, []).compareTo(
                                              a.findTeamTotal(
                                                  outOf, percent, [])));
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
                                    results = DoublePartner.filterBowlers(
                                        bowlers: bowlers,
                                        search: text,
                                        outOf: outOf,
                                        percent: percent);
                                    resultsPartners = DoubleSearchBrain()
                                        .findDoublePartnes(
                                            bowlers,
                                            results,
                                            selectedSquad,
                                            selectedDivisions[selectedSquad]);
                                    resultsPartners.sort((a, b) => b
                                        .findTeamTotal(outOf, percent, []).compareTo(
                                            a.findTeamTotal(
                                                outOf, percent, [])));
                                  });
                                }),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Scrollbar(
                                isAlwaysShown: true,
                                child: ListView.builder(
                                    itemCount: resultsPartners.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DoubleScoreScreen(
                                                          bowler: resultsPartners[
                                                              index])));
                                        },
                                        leading: SizedBox(
                                            width: 700,
                                            child: Row(
                                              children: [
                                                Text(resultsPartners[index]
                                                    .returnFirstName()),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(MdiIcons.arrowRightBold),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(resultsPartners[index]
                                                    .returnSecondName()),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                    resultsPartners[index].squad),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(resultsPartners[index]
                                                    .findTeamTotal(outOf, percent,
                                                        []).toString()),
                                                resultsPartners[index].isNoError(
                                                            selectedSquad) ==
                                                        ''
                                                    ? SizedBox()
                                                    : IconButton(
                                                        onPressed: () {
                                                          BasicPopUp()
                                                              .showBasicDialog(
                                                                  context,
                                                                  resultsPartners[
                                                                          index]
                                                                      .isNoError(
                                                                          selectedSquad));
                                                        },
                                                        icon: Icon(
                                                          Icons.warning,
                                                          color: Colors.red,
                                                        ))
                                              ],
                                            )),
                                        trailing: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              MdiIcons.chevronRight,
                                            )),
                                      );
                                    }),
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
