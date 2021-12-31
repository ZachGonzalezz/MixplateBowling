import 'package:flutter/material.dart';
import 'package:lois_bowling_website/NavigationBar/navigation_row.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomNavigationBar extends StatelessWidget {
  CustomNavigationBar({ Key? key, required this.selected }) : super(key: key);

  String selected;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.15 ,
      child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                    children: [
                      NavigationRow(icon: Icons.arrow_back_ios_rounded, screeName: 'Tournaments', sendTo:  Constants.tournamentHome, isSelected:  false,),
                      NavigationRow(icon: Icons.settings, screeName: 'Settings', sendTo:  Constants.settingsHome, isSelected: 'Settings' == selected,),
                      // NavigationRow(icon: MdiIcons.tournament, screeName: 'Brackets', sendTo:  Constants.settingsHome, isSelected: 'Brackets' == selected,),
                      NavigationRow(icon: Icons.add, screeName: 'Create Bowler', sendTo:  Constants.createNewBowler, isSelected: 'Create Bowler' == selected,),
                      NavigationRow(icon: Icons.person, screeName: 'Singles', sendTo:  Constants.searchSingles, isSelected: 'Singles' == selected,),
                      NavigationRow(icon: Icons.groups_rounded, screeName: 'Doubles', sendTo:  Constants.searchDoubles, isSelected: 'Doubles' == selected,),
                      NavigationRow(icon: MdiIcons.accountGroup, screeName: 'Teams', sendTo:  Constants.teamSearch, isSelected: 'Teams' == selected,),
                      NavigationRow(icon: MdiIcons.bowling, screeName: 'Bowlers', sendTo:  Constants.searchBowlers, isSelected: 'Bowlers' == selected,),
                      NavigationRow(icon: MdiIcons.scoreboard, screeName: 'Scores', sendTo:  Constants.inputScores, isSelected: 'Scores' == selected,),
                      NavigationRow(icon: Icons.attach_money_rounded, screeName: 'Finances', sendTo:  Constants.financeScreen, isSelected: 'Finances' == selected,),
                      // NavigationRow(icon: MdiIcons.crown, screeName: 'Winners', sendTo:  Constants.settingsHome, isSelected: 'Winners' == selected,),
                      // NavigationRow(icon: MdiIcons.roadVariant, screeName: 'Lanes', sendTo:  Constants.settingsHome, isSelected:  'Lanes' == selected,),
                      NavigationRow(icon: Icons.logout, screeName: 'Logout', sendTo:  Constants.home, isSelected: false),
                      
                
      
                    ]
                     
      
                    ),
                  ),
                ),
    );
  }
}