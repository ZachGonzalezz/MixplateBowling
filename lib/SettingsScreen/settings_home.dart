import 'package:flutter/material.dart';
import 'package:lois_bowling_website/AddDoublePartner/partner_brain.dart';
import 'package:lois_bowling_website/ImportBowlers/importBowlersPopup.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/SettingsScreen/setting_section_tile.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_input_value_tile.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:lois_bowling_website/universal_ui.dart/basic_screen_layout.dart';
import 'package:lois_bowling_website/universal_ui.dart/squad_picker.dart';

class SettingsHome extends StatefulWidget {
  SettingsHome({Key? key}) : super(key: key);

  @override
  State<SettingsHome> createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  SettingsBrain brain = SettingsBrain();
  bool isAll = false;
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
        if(value['isAllDoubles'] == 1){
          isAll = true;
        }
      });
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
                          CustomButton(
                            buttonTitle: 'Save Settings',
                            length: 300,
                            onClicked: () {
                              brain.saveHomeSettings();
                            },
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
                            title: 'Entrees Fee',
                            brain: brain,
                            miscSettings: brain.miscSettings,
                          ),
                          InputValueTileSettings(
                            title: 'Handicapt Amount',
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
                          TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => ImportBowlersPopUp());
                            },
                            child: Text('Import Bowlers'),
                          )
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
