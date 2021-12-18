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
     Map<int, Color> colorCodes = {
      50: Color.fromRGBO(147, 205, 72, .1),
      100: Color.fromRGBO(147, 205, 72, .2),
      200: Color.fromRGBO(147, 205, 72, .3),
      300: Color.fromRGBO(147, 205, 72, .4),
      400: Color.fromRGBO(147, 205, 72, .5),
      500: Color.fromRGBO(147, 205, 72, .6),
      600: Color.fromRGBO(147, 205, 72, .7),
      700: Color.fromRGBO(147, 205, 72, .8),
      800: Color.fromRGBO(147, 205, 72, .9),
      900: Color.fromRGBO(147, 205, 72, 1),
    };

    MaterialColor color = new MaterialColor(0xFF93cd48, colorCodes);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            
            Text(widget.title),
            Checkbox(
                value: widget.brain.divisions.contains(widget.brain.divisionSelectedSquad + ' ' +  widget.title),
                activeColor: Colors.red,
                fillColor:  widget.brain.greyOutBoxed.contains(widget.brain.divisionSelectedSquad + ' ' +  widget.title) ? MaterialStateProperty.all<Color>(Colors.pink) : MaterialStateProperty.all<Color>(Colors.black),
                onChanged:
                 widget.brain.greyOutBoxed.contains(widget.brain.divisionSelectedSquad + ' ' + widget.title) ? null :(isChecked) {
                  //calls function in widget
            
                  if (widget.brain.divisions.contains(widget.brain.divisionSelectedSquad + ' ' +  widget.title)) {
                    setState(() {
                      //removes the divison from the list
                      widget.brain.divisions.remove(widget.brain.divisionSelectedSquad + ' ' +  widget.title);
                    });
                  } else {
                    setState(() {
                      //adds the divison from the list
                      widget.brain.divisions.add( widget.brain.divisionSelectedSquad + ' ' + widget.title);
                    });
                  }
                        widget.changeValues(isChecked ?? false);
                }
                )
          ],
        ));
  }
}
