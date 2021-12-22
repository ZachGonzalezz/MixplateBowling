import 'package:flutter/material.dart';
import 'package:lois_bowling_website/AddDoublePartner/partner_brain.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';
import 'package:lois_bowling_website/SinglesScreen/single_screen.dart';
import 'package:lois_bowling_website/bowler.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:lois_bowling_website/universal_ui.dart/basic_screen_layout.dart';
import 'package:lois_bowling_website/universal_ui.dart/search_bar.dart';
import 'package:lois_bowling_website/universal_ui.dart/squad_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchSinglesScreen extends StatefulWidget {
  const SearchSinglesScreen({Key? key}) : super(key: key);

  @override
  _SearchSinglesScreenState createState() => _SearchSinglesScreenState();
}

class _SearchSinglesScreenState extends State<SearchSinglesScreen> {
  SettingsBrain brain = SettingsBrain();
  int amountOfSquads = 1;

  List<String> divisions = ['No Division'];

  String selectedSquad = 'A';
  //this keeps track of which division is selecter per Squad sotred in {"A" : "A Singles (One Division)"}
  Map<String, String> selectedDivisions = {};

  //this is the original array from the database
  List<Bowler> bowlers = [];
  //this this the list returned
  List<Bowler> results = [];

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
         results = DoublePartner.filterBowlers(
                                        bowlers: bowlers, search: '', squad: 'A');
      });
    });
  }

//loads the number of squads in the current tournament (based on name held in local storage)
  void loadTournamentSettings() {
    SettingsBrain().getMainSettings().then((basicSettings) {
      setState(() {
        amountOfSquads = (basicSettings['Squads'] ?? 1).toInt();
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
                                // DivisionPicker(
                                //   division: divisions,
                                //   selectedSquad: selectedSquad,
                                //   selectedDivision: selectedDivisions,
                                //   onDivisionChange: (newDivision){
                                //     selectedDivisions[selectedSquad] = newDivision;
                                //   },
                                // ),
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
                                        bowlers: bowlers, search: text);
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                   SingleScoreScreen(bowler: results[index])));
                                      },
                                      leading: SizedBox(
                                        width: 500,
                                        child: Row(
                                          children: [
                                            Text(results[index].firstName +
                                                ' ' +
                                                results[index].lastName, style: TextStyle(fontWeight: FontWeight.w700, ),),

                                                SizedBox(width: 20,),
                                              Text(results[index].divisions[selectedSquad  + 'Singles'] ?? ''),
                                                 SizedBox(width: 20,),

                                                Text(results[index].findScoreForSquad(selectedSquad).toString())
                                          ],
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            MdiIcons.chevronRight,
                                          )),
                                    );
                                  }),
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
