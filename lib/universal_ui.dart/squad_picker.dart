import 'package:flutter/material.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';
import 'package:lois_bowling_website/constants.dart';

class SquadPicker extends StatefulWidget {
  SquadPicker(
      {Key? key,
      this.brain,
      required this.chnageSquads,
      required this.numberOfSquads})
      : super(key: key);
  SettingsBrain? brain;
  int numberOfSquads;
  Function(String) chnageSquads;

  @override
  State<SquadPicker> createState() => _SquadPickerState();
}

class _SquadPickerState extends State<SquadPicker> {
  String selected = 'A';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: DropdownButton(
              underline: null,
              elevation: 0,
              onChanged: (String? value) {
                widget.chnageSquads(value ?? "A");
                setState(() {
                  selected = value!;
                });
              },
              value: selected,
              items: Constants.findSquads(widget.numberOfSquads)
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('Squad ' + value),
                );
              }).toList(),
            ),
          )),
    );
  }
}
