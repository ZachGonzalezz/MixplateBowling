import 'package:flutter/material.dart';
import 'package:lois_bowling_website/CreateBowler/create_bowler_brain.dart';
import 'package:lois_bowling_website/CreateBowler/gender_picker.dart';
import 'package:lois_bowling_website/CreateBowler/input_textfield.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:lois_bowling_website/universal_ui.dart/basic_popup.dart';
import 'package:lois_bowling_website/universal_ui.dart/basic_screen_layout.dart';
import 'package:lois_bowling_website/universal_ui.dart/division_picker.dart';
import 'package:lois_bowling_website/universal_ui.dart/squad_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CreateNewBowlerScreen extends StatefulWidget {
  CreateNewBowlerScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewBowlerScreen> createState() => _CreateNewBowlerScreenState();
}

class _CreateNewBowlerScreenState extends State<CreateNewBowlerScreen> {
  CreateBowlerBrain brain = CreateBowlerBrain();
  int amountOfSquads = 1;

  List<String> divisions = ['No Division'];

  String selectedSquad = 'A';
  //this keeps track of which division is selecter per Squad sotred in {"A" : "A Singles (One Division)"}
  Map<String, String> selectedDivisions = {};

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
                            SizedBox(height: 30),
                            //these are the textfields to enter infromation controllers are held in create brain to be used to save in DB
                            Row(children: [
                              SpecialTextField(
                                item: 'First Name',
                                controller: brain.firstNameController,
                              ),
                              SizedBox(
                                width: 60,
                              ),
                              SpecialTextField(
                                item: 'Last Name',
                                controller: brain.lastNameController,
                              ),
                            ]),
                            SizedBox(height: 30),
                            Row(children: [
                              SpecialTextField(
                                item: 'Average',
                                controller: brain.averageController,
                              ),
                              SizedBox(
                                width: 60,
                              ),
                              SpecialTextField(
                                  item: 'Handicap',
                                  controller: brain.handicapController),
                            ]),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                SpecialTextField(
                                    item: 'Side Pots',
                                    controller: brain.sidePotController),
                                SizedBox(
                                  width: 60,
                                ),
                                //this is the female picker
                                GenderPicker(
                                  isMale: false,
                                  brain: brain,
                                  valueChanged: () {
                                    setState(() {
                                      //if they already selected is female = false then make it null unselecting female
                                      if (brain.isMale == false) {
                                        brain.isMale = null;
                                      } else {
                                        //this set there gender as not male meaning female
                                        brain.isMale = false;
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                //this is the male picker
                                GenderPicker(
                                  isMale: true,
                                  brain: brain,
                                  valueChanged: () {
                                    setState(() {
                                      //if they selected male already then unselect it since they are tapping a selected tile
                                      if (brain.isMale == true) {
                                        brain.isMale = null;
                                      } else {
                                        //means they are selecting male
                                        brain.isMale = true;
                                      }
                                    });
                                  },
                                ),
                              ],
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
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: const [
                                  Icon(MdiIcons.accountGroup, 
                                  size: 50
                                  ),
                                  Text('Teams', style: TextStyle(fontSize: 20, fontWeight:FontWeight.w700))
                                ]),
                                SizedBox(width: 100,),
                                Column(children: const [
                                  Icon(MdiIcons.accountMultiple,
                                   size: 50),
                                  Text('Double',  style: TextStyle(fontSize: 20, fontWeight:FontWeight.w700))
                                ])
                              ],
                            ),
                                  SizedBox(height: 30),
                            Center(
                              child: CustomButton(
                                buttonTitle: 'Save New Bowler',
                                length: 300,
                                onClicked: () {
                                  //if returns '' no errors else display error code do not save user to db incomplete
                                  String error = brain.isGoodToSavePerson();
                                  if(error == ''){
                                    brain.selectedSinglesDivisions = selectedDivisions;
                                    brain.saveNewBowler();
                                  }
                                  else{
                                    BasicPopUp(text: error).showBasicDialog(context, error);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                           
                          ]),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
