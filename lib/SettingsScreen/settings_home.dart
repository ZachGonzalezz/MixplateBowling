import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/AddDoublePartner/partner_brain.dart';
import 'package:loisbowlingwebsite/ImportBowlers/importBowlersPopup.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/setting_section_tile.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_input_value_tile.dart';
import 'package:loisbowlingwebsite/TournamentCreateNewScreen/share_popup.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/squad_picker.dart';

class SettingsHome extends StatefulWidget {
  SettingsHome({Key? key}) : super(key: key);

  @override
  State<SettingsHome> createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  SettingsBrain brain = SettingsBrain();
  bool isAll = false;
  String name = '';
  DateTime to = DateTime.now();
  DateTime from = DateTime.now();
  List<String> sharedWith = [];
  String tournId = '';
  String squadsForDoubleAll = 'A';
  @override
  void initState() {
    super.initState();
    Constants.saveTournamentIdBeforeRefresh();
    loadSettings();
  }

  Future<void> loadSettings() async {
    await brain.getMainSettings().then((value) {
      setState(() {
        brain.miscSettings = value;
        //if 1 then is means user selected it so make box checked so user cant click it again
        if (value['isAllDoubles'] == 1) {
          isAll = true;
        }
     
      });
    });

    await brain.getOtherSettings().then((value) {
      name = value['name'] ?? '';
      Timestamp toStamp = value['to'] ?? Timestamp.now();
      Timestamp fromStamp = value['from'] ?? Timestamp.now();
      sharedWith = List.from(value['sharedWith'] ?? []);

      to = toStamp.toDate();
      from = fromStamp.toDate();
      tournId = value['id'] ?? '';
      
    });
    return;
  }
// obtain shared preferences

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, Constants.tournamentHome);
        return Future(() => true);
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(context, Constants.settingsHome);
          return true;
        },
        child: Scaffold(
          body: ScreenLayout(
            selected: 'Settings',
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
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            Constants.tournamentName,
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 30),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Builder(
                          builder:(ctx) => CustomButton(
                              buttonTitle: 'Save Settings',
                              length: 300,
                              onClicked: () {
                               
                                
                                 Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Saved', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),),);
                                brain.saveHomeSettings();
                              },
                            ),
                          ),
                          SettingSelectionTile(
                            title: 'Divisions',
                            navigateTo: Constants.settingsDivision,
                            brain: brain,
                          ),
                          // SettingSelectionTile(
                          //   title: 'Spot Earnings',
                          //   navigateTo: Constants.settingsDivision,
                          //   brain: brain,
                          // ),
                          SettingSelectionTile(
                            title: 'Side Pots',
                            navigateTo: Constants.sidePotSettings,
                            brain: brain,
                          ),
                          InputValueTileSettings(
                            title: 'Entry Fee',
                            brain: brain,
                            miscSettings: brain.miscSettings,
                          ),
                          InputValueTileSettings(
                            title: 'Handicap Amount',
                            brain: brain,
                            miscSettings: brain.miscSettings,
                          ),
                          InputValueTileSettings(
                            title: 'Handicap Percentage',
                            brain: brain,
                            miscSettings: brain.miscSettings,
                          ),
                          InputValueTileSettings(
                            title: 'Squads',
                            brain: brain,
                            miscSettings: brain.miscSettings,
                          ),
                          InputValueTileSettings(
                            title: 'Team Size',
                            brain: brain,
                            miscSettings: brain.miscSettings,
                          ),
                          InputValueTileSettings(
                            title: 'Max on A Lane',
                            brain: brain,
                            miscSettings: brain.miscSettings,
                          ),
                          InputValueTileSettings(
                            title: 'Games',
                            brain: brain,
                            miscSettings: brain.miscSettings,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                  value: isAll,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isAll = !isAll;
                                    });

                                    if (isAll) {
                                      DoublePartner()
                                          .allBolwers(squadsForDoubleAll);
                                      //since map is <String, double> we store as 1 == true and 0 == false
                                      brain.miscSettings['isAllDoubles'] = 1;
                                    } else {
                                      DoublePartner()
                                          .removeAllBowler(squadsForDoubleAll);
                                      brain.miscSettings['isAllDoubles'] = 0;
                                    }
                                    brain.saveHomeSettings();
                                  }),
                              Text('All Doubles'),
                              SizedBox(
                                width: 20,
                              ),
                              SquadPicker(
                                  chnageSquads: (newSquad) {
                                    setState(() {
                                      squadsForDoubleAll = newSquad;
                                    });
                                  },
                                  numberOfSquads:
                                      (brain.miscSettings['Squads'] ?? 1)
                                          .toInt())
                            ],
                          ),
                          SizedBox(
                            height: 30
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => ImportBowlersPopUp());
                            },
                            child: Text('Import Bowlers'),
                          ),
                          SizedBox(
                            height: 30
                          ),
                            TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => SharePopUp(emailsToSendTo: sharedWith, name:  name, to:  to, from: from, isTournamnetCreatedAlready: true, id: tournId,));
                            },
                            child: Text('Share'),
                          ),
                            SizedBox(
                            height: 30
                          ),
                        ])),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
