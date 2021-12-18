import 'package:flutter/material.dart';
import 'package:lois_bowling_website/SettingsScreen/DivisionSettings/checkbox_tile.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';

class SinglesDivisionList extends StatefulWidget {
  SinglesDivisionList({Key? key, required this.brain}) : super(key: key);
  SettingsBrain brain;
  @override
  State<SinglesDivisionList> createState() => _SinglesDivisionListState();
}

class _SinglesDivisionListState extends State<SinglesDivisionList> {
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
            title: 'Singles Scratch (One Division)',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Singles Scratch (One Division)'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Singles Scratch (One Division)');
              });
            }),
        CheckBoxTile(
            title: 'Men\'s Singles Scratch',
            brain: widget.brain,
            isGreyedOut:
                widget.brain.greyOutBoxed.contains('Men\'s Singles Scratch'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Men\'s Singles Scratch');
              });
            }),
        CheckBoxTile(
            title: 'Women\'s Singles Scratch',
            brain: widget.brain,
            isGreyedOut:
                widget.brain.greyOutBoxed.contains('Women\'s Singles Scratch'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Women\'s Singles Scratch');
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
            title: 'Singles Handicap (One Division)',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Singles Handicap (One Division)'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Singles Handicap (One Division)');
              });
            }),
        CheckBoxTile(
            title: 'Men\'s Singles Handicap',
            brain: widget.brain,
            isGreyedOut:
                widget.brain.greyOutBoxed.contains('Men\'s Singles Handicap'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Men\'s Singles Handicap');
              });
            }),
        CheckBoxTile(
            title: 'Women\'s Singles Handicap',
            brain: widget.brain,
            isGreyedOut:
                widget.brain.greyOutBoxed.contains('Women\'s Singles Handicap'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Women\'s Singles Handicap');
              });
            }),
        CheckBoxTile(
            title: 'Men\'s Singles Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Men\'s Singles Handicap Low'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Men\'s Singles Handicap Low');
              });
            }),
        CheckBoxTile(
            title: 'Men\'s Singles Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Men\'s Singles Handicap High'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain
                    .newBoxedChecked(isChecked, 'Men\'s Singles Handicap High');
              });
            }),
        CheckBoxTile(
            title: 'Women\'s Singles Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Women\'s Singles Handicap Low'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Women\'s Singles Handicap Low');
              });
            }),
        CheckBoxTile(
            title: 'Women\'s Singles Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Women\'s Singles Handicap High'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Women\'s Singles Handicap High');
              });
            }),
        CheckBoxTile(
            title: 'Singles Gender Neutural Handicap Low',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Singles Gender Neutural Handicap Low'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Singles Gender Neutural Handicap Low');
              });
            }),
        CheckBoxTile(
            title: 'Singles Gender Neutural Handicap High',
            brain: widget.brain,
            isGreyedOut: widget.brain.greyOutBoxed
                .contains('Singles Gender Neutural Handicap High'),
            divisionType: 'Singles',
            changeValues: (isChecked) {
              //remove function
              setState(() {
                widget.brain.newBoxedChecked(
                    isChecked, 'Singles Gender Neutural Handicap High');
              });
            }),
      ],
    );
  }
}
