import 'package:flutter/material.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';


class CheckBoxTile extends StatefulWidget {
  CheckBoxTile({ Key? key,
  required this.title,
  required this.brain,
  required this.changeValues,
  required this.isGreyedOut
   }) : super(key: key);

  String title;
  SettingsBrain brain;
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
        Checkbox(value: widget.brain.divisions.contains(widget.title), onChanged: widget.isGreyedOut ? null : (isChecked){
          widget.changeValues(isChecked ?? false);
          if(widget.brain.divisions.contains(widget.title)){
            setState(() {
              widget.brain.divisions.remove(widget.title);
            });
          }
          else{
             setState(() {
              widget.brain.divisions.add(widget.title);
            });
          }

        })
      ],
    )
      
    );
  }
}