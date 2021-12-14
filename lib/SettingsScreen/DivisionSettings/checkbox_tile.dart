import 'package:flutter/material.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';

class CheckBoxTile extends StatefulWidget {
  CheckBoxTile({
    Key? key,
    required this.title,
    required this.brain,
    required this.changeValues,
    required this.isGreyedOut,
    required this.divisionType,
  }) : super(key: key);

  //this is the part 'singles handicap' this name will be used in db
  String title;
  //this is singles doubles or teams
  String divisionType;
  //this holds all the information about division user has selected
  SettingsBrain brain;
  //called when user checks or unchecks a boxe
  Function(bool) changeValues;
  bool isGreyedOut;
  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    print(widget.isGreyedOut);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            
            Text(widget.title),
            Checkbox(
                value: widget.brain.divisions.contains(widget.title),
                onChanged: (isChecked) {
                  widget.changeValues(isChecked ?? false);
                  if (widget.brain.divisions.contains(widget.title)) {
                    setState(() {
                      widget.brain.divisions.remove(widget.title);
                    });
                  } else {
                    setState(() {
                      widget.brain.divisions.add(widget.title);
                    });
                  }
                })
          ],
        ));
  }
}
