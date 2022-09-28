import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/SettingsScreen/DivisionSettings/checkbox_tile.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';

class SeniorDivisionList extends StatefulWidget {
  SeniorDivisionList({Key? key, required this.brain}) : super(key: key);
  SettingsBrain brain;

  @override
  _SeniorDivisionListState createState() => _SeniorDivisionListState();
}

class _SeniorDivisionListState extends State<SeniorDivisionList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Scratch',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CheckBoxTile(
            title: 'Senior Scratch (One Division)',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Senior Scratch (One Division)'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Senior Scratch (One Division)');
              });
            }),
        CheckBoxTile(
            title: 'Men\'s Senior Scratch',
            brain: widget.brain,
            isGreyedOut:
                widget.brain.greyOutBoxed.contains('Men\'s Senior Scratch'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Men\'s Senior Scratch');
              });
            }),
        CheckBoxTile(
            title: 'Women\'s Senior Scratch',
            brain: widget.brain,
            isGreyedOut:
                widget.brain.greyOutBoxed.contains('Women\'s Senior Scratch'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Women\'s Senior Scratch');
              });
            }),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Handicap',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CheckBoxTile(
            title: 'Senior Handicap (One Division)',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Senior Handicap (One Division)'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Senior Handicap (One Division)');
              });
            }),
        CheckBoxTile(
            title: 'Men\'s Senior Handicap',
            brain: widget.brain,
            isGreyedOut:
                widget.brain.greyOutBoxed.contains('Men\'s Senior Handicap'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Men\'s Senior Handicap');
              });
            }),
        CheckBoxTile(
            title: 'Women\'s Senior Handicap',
            brain: widget.brain,
            isGreyedOut:
                widget.brain.greyOutBoxed.contains('Women\'s Senior Handicap'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Women\'s Senior Handicap');
              });
            }),
        CheckBoxTile(
            title: 'Men\'s Senior Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Men\'s Senior Handicap Low'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Men\'s Senior Handicap) Low');
              });
            }),
        CheckBoxTile(
            title: 'Men\'s Senior Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Men\'s Senior Handicap High'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Men\'s Senior Handicap) High');
              });
            }),
        CheckBoxTile(
            title: 'Women\'s Senior Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Women\'s Senior Handicap Low'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Women\'s Senior Handicap Low');
              });
            }),
        CheckBoxTile(
            title: 'Women\'s Senior Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Women\'s Senior Handicap High'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Women\'s Senior Handicap High');
              });
            }),
        CheckBoxTile(
            title: 'Senior Gender Neutural Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Senior Gender Neutural Handicap Low'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Senior Gender Neutural Handicap Low');
              });
            }),
        CheckBoxTile(
            title: 'Senior Gender Neutural Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Senior Gender Neutural Handicap High'),
            divisionType: 'Senior',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Senior Gender Neutural Handicap High');
              });
            }),
      ],
    );
  }
}
