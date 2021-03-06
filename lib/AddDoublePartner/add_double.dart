import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/AddDoublePartner/partner_brain.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/search_bar.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/squad_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddDoublePartnerScreen extends StatefulWidget {
  AddDoublePartnerScreen({Key? key, this.partnersSaved, this.bowler}) : super(key: key);

  Map<String, dynamic>? partnersSaved;
  Bowler? bowler;

  @override
  State<AddDoublePartnerScreen> createState() => _AddDoublePartnerScreenState();
}

class _AddDoublePartnerScreenState extends State<AddDoublePartnerScreen> {
  SettingsBrain brain = SettingsBrain();
  int amountOfSquads = 1;

  int outOf = 200;
  int percent = 100;

  List<String> divisions = ['No Division'];

  String selectedSquad = 'A';
  //this keeps track of which division is selecter per Squad sotred in {"A" : "A Singles (One Division)"}
  Map<String, String> selectedDivisions = {};

  //this is the original array from the database
  List<Bowler> bowlers = [];
  //this this the list returned
  List<Bowler> results = [];

//if selected then every single bowler is their double partner
  bool isAll = false;

  //this is the list of double partners the user has selected
  Map<String, dynamic> doublePartner = {};
  @override
  void initState() {
    super.initState();
    loadTournamentSettings();
    loadBowlers();

    
    //if the user already has double partners will pass it over here
   
  }

  void loadBowlers() {
    DoublePartner.loadBowlers().then((bowlersFromDB) {
      setState(() {
        bowlers = bowlersFromDB;
        results = bowlersFromDB;
      });
        if (widget.partnersSaved != null) {
      doublePartner = widget.partnersSaved!;
    }
       setState(() {
          results = DoublePartner.filterBowlers(
                                        bowlers: bowlers,
                                        doublePartners: doublePartner,
                                        search: '',
                                        peopleOnSheet: widget.bowler?.bowlerSheetIds,
                                        outOf: outOf,
                                        percent: percent);
    });
    });
   
   
 
  }

  int findBowlers(){
    int count = 0;


    bowlers.forEach((element) {
      // var test = ;
     if ( (doublePartner[selectedSquad] ?? []).contains(element.uniqueId) ) {
count ++;
      }
    });

     

     return count;


    //  .contains(results[index].uniqueId)
  }

//loads the number of squads in the current tournament (based on name held in local storage)
  void loadTournamentSettings() {
    SettingsBrain().getMainSettings().then((basicSettings) {
      setState(() {
        amountOfSquads = (basicSettings['Squads'] ?? 1).toInt();
        percent = (basicSettings['Handicap Percentage'] ?? 100).toInt();
        outOf = (basicSettings['Handicap Amount'] ?? 200).toInt();
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
                            BackButton(),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text((findBowlers().toString() + ' In Toal ' + widget.bowler!.bowlerSheetIds.length.toString() + ' On this persons Sheet and ' + (findBowlers() - widget.bowler!.bowlerSheetIds.length).toString() + ' On other sheets'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700), ),
                              
                            ),
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
                                Checkbox(
                                    value: isAll,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isAll = true;
                                      });
                                      doublePartner[selectedSquad] = [];
                                      results.forEach((element) {
                                        setState(() {
                                          (doublePartner[selectedSquad] ?? [])
                                              .add(element.uniqueId);
                                        });
                                      });
                                      print(doublePartner[selectedSquad]);
                                    }),
                                Text('All')
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
                                        doublePartners: doublePartner,
                                          peopleOnSheet: widget.bowler?.bowlerSheetIds,
                                        search: text,
                                        outOf: outOf,
                                        percent: percent);
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
                                    return Container(
                                      color: widget.bowler!.bowlerSheetIds.contains(results[index].uniqueId) ? Colors.pink[200] : (doublePartner[selectedSquad] ??
                                                            [])
                                                        .contains(results[index]
                                                            .uniqueId) ? Colors.grey[400] : null,
                                      child: ListTile(
                                       
                                        leading: SizedBox(
                                          width: 300,
                                          child: Row(
                                            children: [
                                              Text((index + 1).toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(results[index].firstName +
                                                  ' ' +
                                                  results[index].lastName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                                            ],
                                          ),
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              //this means person added already and now needs to undo
                                              if ((doublePartner[selectedSquad] ??
                                                      [])
                                                  .contains(
                                                      results[index].uniqueId)) {
                                                setState(() {
                                                  (doublePartner[selectedSquad] ??
                                                          [])
                                                      .remove(results[index]
                                                          .uniqueId);
                                                    widget.bowler?.bowlerSheetIds.remove(results[index].uniqueId);
                                                    
                                                    
                                                });
                                              } else {
                                                if (doublePartner[
                                                        selectedSquad] ==
                                                    null) {
                                                  doublePartner[selectedSquad] =
                                                      [];
                                                }
                                                setState(() {
                                                  (doublePartner[selectedSquad] ??
                                                          [])
                                                      .add(results[index]
                                                          .uniqueId);
                                                widget.bowler?.bowlerSheetIds.add(results[index].uniqueId);
                                                });
                                              }
                                            },
                                            icon: Icon(
                                              MdiIcons.plus,
                                              
                                              color:
                                                  (doublePartner[selectedSquad] ??
                                                              [])
                                                          .contains(results[index]
                                                              .uniqueId)
                                                      ? Colors.pink
                                                      : null,
                                            ),
                                            iconSize: 37,),
                                      ),
                                    );
                                  }),
                            ),
                            Center(
                              child: CustomButton(
                                buttonTitle: 'Finalize',
                                length: 300,
                                onClicked: () {
                                  widget.bowler?.updateBowlerDoubles();
                                  Navigator.pop(context, doublePartner);
                                },
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
