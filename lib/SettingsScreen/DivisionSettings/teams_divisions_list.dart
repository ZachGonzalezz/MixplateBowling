import 'package:flutter/material.dart';
import 'package:lois_bowling_website/SettingsScreen/DivisionSettings/checkbox_tile.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';

class TeamsDivisionList extends StatefulWidget {
 TeamsDivisionList({ Key? key, required this.brain }) : super(key: key);
  SettingsBrain brain;

  @override
  _TeamsDivisionListState createState() => _TeamsDivisionListState();
}

class _TeamsDivisionListState extends State<TeamsDivisionList> {
  @override
  Widget build(BuildContext context) {
   return ListView(

      children: [
        const SizedBox(height: 20,),
       const Padding(
          padding: EdgeInsets.only(left:20),
          child: Text('Scratch', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
        ),
        const SizedBox(height: 20,),
        CheckBoxTile(
            title: 'Team Scratch (One Division)',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Team Scratch (One Division)'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Team Scratch (One Division)');
              });
            }),
          CheckBoxTile(
            title: 'Men\'s Team Scratch',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Men\'s Team Scratch'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Men\'s Team Scratch');
              });
            }),
             CheckBoxTile(
            title: 'Women\'s Team Scratch',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Women\'s Team Scratch'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Women\'s Team Scratch');
              });
            }),
            const SizedBox(height: 20,),
 const Padding(
          padding: EdgeInsets.only(left:20),
          child: Text('Handicap', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
        ),
        const SizedBox(height: 20,),
            CheckBoxTile(
            title: 'Team Handicap (One Division)',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Team Handicap (One Division)'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Team Handicap (One Division)');
              });
            }),

              CheckBoxTile(
            title: 'Men\'s Team Handicap',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Men\'s Team Handicap'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Men\'s Team Handicap');
              });
            }),

             CheckBoxTile(
            title: 'Women\'s Team Handicap',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Women\'s Team Handicap'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Women\'s Team Handicap');
              });
            }),

             CheckBoxTile(
            title: 'Men\'s Team Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Men\'s Team Handicap Low'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Men\'s Team Handicap) Low');
              });
            }),

             CheckBoxTile(
            title: 'Men\'s Team Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Men\'s Team Handicap High'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Men\'s Team Handicap) High');
              });
            }),


            

            CheckBoxTile(
            title: 'Women\'s Team Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Women\'s Team Handicap Low'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Women\'s Team Handicap Low');
              });
            }),

             CheckBoxTile(
            title: 'Women\'s Team Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Women\'s Team Handicap High'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Women\'s Team Handicap High');
              });
            }),


             CheckBoxTile(
            title: 'Team Gender Neutural Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Team Gender Neutural Handicap Low'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Team Gender Neutural Handicap Low');
              });
            }),

             CheckBoxTile(
            title: 'Team Gender Neutural Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Team Gender Neutural Handicap High'),
            divisionType: 'Team',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Team Gender Neutural Handicap High');
              });
            }),


            
            
      ],
    );
  }
}