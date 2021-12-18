import 'package:flutter/material.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/SettingsScreen/setting_section_tile.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_input_value_tile.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:lois_bowling_website/universal_ui.dart/basic_screen_layout.dart';

class SettingsHome extends StatefulWidget {
  SettingsHome({Key? key}) : super(key: key);

  @override
  State<SettingsHome> createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  SettingsBrain brain = SettingsBrain();

  @override
  void initState() {
    super.initState();
    Constants.saveTournamentIdBeforeRefresh();
   loadSettings();
  }

  Future<void> loadSettings() async {
   await  brain.getMainSettings().then((value) {
      
      setState(() {
        brain.miscSettings = value;
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
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          Constants.tournamentName,
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 30),
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
                        SettingSelectionTile(
                          title: 'Spot Earnings',
                          navigateTo: Constants.settingsDivision,
                          brain: brain,
                        ),
                        SettingSelectionTile(
                          title: 'Side Pots Amount',
                          navigateTo: Constants.settingsDivision,
                          brain: brain,
                        ),
                        InputValueTileSettings(
                            title: 'Entrees Fee', brain: brain, miscSettings: brain.miscSettings,),
                        InputValueTileSettings(
                            title: 'Handicapt Amount', brain: brain, miscSettings: brain.miscSettings,),
                        InputValueTileSettings(
                            title: 'Handicap Percentage', brain: brain, miscSettings: brain.miscSettings,),
                        InputValueTileSettings(title: 'Squads', brain: brain, miscSettings: brain.miscSettings,),
                        InputValueTileSettings(
                            title: 'Team Size', brain: brain, miscSettings: brain.miscSettings,),
                        InputValueTileSettings(
                            title: 'Max on A Lane', brain: brain, miscSettings: brain.miscSettings,),
                        InputValueTileSettings(title: 'Games', brain: brain, miscSettings: brain.miscSettings,),
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
