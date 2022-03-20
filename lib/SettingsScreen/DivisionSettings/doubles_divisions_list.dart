import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/SettingsScreen/DivisionSettings/checkbox_tile.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';

class DoubleDivisionList extends StatefulWidget {
 DoubleDivisionList({ Key? key, required this.brain }) : super(key: key);
SettingsBrain brain;
  @override
  _DoubleDivisionListState createState() => _DoubleDivisionListState();
}

class _DoubleDivisionListState extends State<DoubleDivisionList> {
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
            title: 'Doubles Scratch (One Division)',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Doubles Scratch (One Division)'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Doubles Scratch (One Division)');
              });
            }),
          CheckBoxTile(
            title: 'Men\'s Doubles Scratch',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Men\'s Doubles Scratch'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Men\'s Doubles Scratch');
              });
            }),
             CheckBoxTile(
            title: 'Women\'s Doubles Scratch',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Women\'s Doubles Scratch'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Women\'s Doubles Scratch');
              });
            }),
            const SizedBox(height: 20,),
 const Padding(
          padding: EdgeInsets.only(left:20),
          child: Text('Handicap', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
        ),
        const SizedBox(height: 20,),
            CheckBoxTile(
            title: 'Doubles Handicap (One Division)',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Doubles Handicap (One Division)'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Doubles Handicap (One Division)');
              });
            }),

              CheckBoxTile(
            title: 'Men\'s Doubles Handicap',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Men\'s Doubles Handicap'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Men\'s Doubles Handicap');
              });
            }),

             CheckBoxTile(
            title: 'Women\'s Doubles Handicap',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Women\'s Doubles Handicap'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Women\'s Doubles Handicap');
              });
            }),

             CheckBoxTile(
            title: 'Men\'s Doubles Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Men\'s Doubles Handicap Low'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Men\'s Doubles Handicap Low');
              });
            }),

             CheckBoxTile(
            title: 'Men\'s Doubles Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Men\'s Doubles Handicap High'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Men\'s Doubles Handicap High');
              });
            }),


            

            CheckBoxTile(
            title: 'Women\'s Doubles Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Women\'s Doubles Handicap Low'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Women\'s Doubles Handicap Low');
              });
            }),

             CheckBoxTile(
            title: 'Women\'s Doubles Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Women\'s Doubles Handicap High'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Women\'s Doubles Handicap High');
              });
            }),


             CheckBoxTile(
            title: 'Doubles Gender Neutural Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Doubles Gender Neutural Handicap Low'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Doubles Gender Neutural Handicap Low');
              });
            }),

             CheckBoxTile(
            title: 'Doubles Gender Neutural Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed.contains('Doubles Gender Neutural Handicap High'),
            divisionType: 'Doubles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(isChecked, 'Doubles Gender Neutural Handicap High');
              });
            }),


            
            
      ],
    );
  }
}