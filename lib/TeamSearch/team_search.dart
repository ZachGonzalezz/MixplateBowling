import 'package:flutter/material.dart';
import 'package:lois_bowling_website/AddDoublePartner/partner_brain.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';
import 'package:lois_bowling_website/bowler.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:lois_bowling_website/universal_ui.dart/basic_screen_layout.dart';
import 'package:lois_bowling_website/universal_ui.dart/division_picker.dart';
import 'package:lois_bowling_website/universal_ui.dart/search_bar.dart';
import 'package:lois_bowling_website/universal_ui.dart/squad_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class TeamSearchScreen extends StatefulWidget {
  const TeamSearchScreen({ Key? key }) : super(key: key);

  @override
  State<TeamSearchScreen> createState() => _TeamSearchScreenState();
}

class _TeamSearchScreenState extends State<TeamSearchScreen> {
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
  List<Bowler> doublePartner = [];
@override
  void initState() {
    super.initState();
    loadTournamentSettings();
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
                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(child: Text('Make a Team'), onPressed: (){
                                  Navigator.pushNamed(context, Constants.teamCreate);
                                },),
                              ),
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
                                    onDivisionChange: (newDivision){
                                      selectedDivisions[selectedSquad] = newDivision;
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
                              CustomSearchBar(backTo: Constants.createNewBowler, onChange: (text){
                                //when user types in search bar automatically changes who pops up
                                setState(() {
                                           results =    DoublePartner.filterBowlers(bowlers: bowlers, search: text);
                                });
                   
                              }),
                              SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: ListView.builder(
                                  itemCount: results.length,
                                  itemBuilder: (context, index){
                                  return ListTile(
                                    leading: Text(results[index].firstName + ' ' + results[index].lastName),
                                    trailing: IconButton(onPressed: (){
                                      //this means person added already and now needs to undo
                                      if(doublePartner.contains(results[index])){
                                        setState(() {
                                           doublePartner.remove(results[index]);
                                        });
                                      }
                                      else{
                                        setState(() {
                                             doublePartner.add(results[index]); 
                                        });
                                     
                                      }
                                    }, icon: Icon(MdiIcons.plus, 
                                    color: doublePartner.contains(results[index]) ? Colors.blue : null,)),
                                  );
                                }),
                              ),
                                Center(
                                child: CustomButton(
                                  buttonTitle: 'Finalize',
                                  length: 300,
                                  onClicked: () {
                                    
                                    
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