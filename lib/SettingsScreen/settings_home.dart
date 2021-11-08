import 'package:flutter/material.dart';
import 'package:lois_bowling_website/SettingsScreen/setting_section_tile.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_input_value_tile.dart';
import 'package:lois_bowling_website/basic_screen_layout.dart';
import 'package:lois_bowling_website/constants.dart';


class SettingsHome extends StatelessWidget {
   SettingsHome({ Key? key }) : super(key: key);

  SettingsBrain brain = SettingsBrain();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ScreenLayout(selected: 'Settings', child: 
      SingleChildScrollView(
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
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            Constants.tournamentName,
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 30),
                          ),
      
                          SettingSelectionTile(title: 'Divisions', navigateTo: Constants.settingsDivision, brain: brain,),
                          SettingSelectionTile(title: 'Spot Earnings', navigateTo: Constants.settingsDivision, brain: brain,),
                          SettingSelectionTile(title: 'Side Pots Amount', navigateTo: Constants.settingsDivision, brain: brain,),
                          InputValueTileSettings(title: 'Entrees Fee', brain: brain),
                          InputValueTileSettings(title: 'Handicapt Amount', brain: brain),
                          InputValueTileSettings(title: 'Handicap Percentage', brain: brain),
                          InputValueTileSettings(title: 'Squads', brain: brain),
                          InputValueTileSettings(title: 'Team Size', brain: brain),
                          InputValueTileSettings(title: 'Max on A Lane', brain: brain),
                          InputValueTileSettings(title: 'Games', brain: brain),
      
      
                        ]
                          )
      
                  
                      ),
                    ),
                  ),
                ),
      ),
            ),
      
    );
  }
}